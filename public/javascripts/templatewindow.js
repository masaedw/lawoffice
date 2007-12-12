var TemplateWindow = new Object;

Object.extend(TemplateWindow, {
  init: function() {
    new Draggable("template_window");
    Event.observe("template_select", "change", this.select_handler.bind(this));
    Event.observe("template_window_new",    "click", this.create_template.bind(this));
    Event.observe("template_window_save",   "click", this.update_template.bind(this));
    Event.observe("template_window_delete", "click", this.delete_template.bind(this));
    this.template_observer = new Form.Observer("template_window_form",  1.5, function(element, value) {TemplateWindow.edit_handler();});
    Element.hide("template_window");
  },

  open: function(id) {
    this.new_mode();
    $("template_select_none").selected = true;
    $("template_window").show();
  },

  close: function(id) {
    Element.hide("template_window");
  },

  new_mode: function() {
    this.template_id = "";
    this.mode = "new";
    $("template_window_new").show();
    $("template_window_save").hide();
    $("template_window_delete").hide();
    this.show(null);
  },

  edit_mode: function(id) {
    this.template_id = id;
    this.mode = "edit";
    $("template_window_new").hide();
    $("template_window_save").show();
    $("template_window_save").disabled = true;
    $("template_window_delete").show();
    this.show(MemoTemplate.find(id));
  },

  show: function(template) {
    var id;

    if (!template) {
      template = {name: "", color: "#fff", content :""};
      id = 0
    } else {
      id = template.id_number();
    }

    j$('#template_select option[@value=#{id}]'.interpolate({id:id}))[0].selected = true;
    $("template_window_name").value = template.name;
    $("template_window_color").value = template.color;
    $("template_window_area").value = template.content;
    $("template_window_area").style.backgroundColor = template.color;
    this.template_observer.updateLastValue();
  },

  select_handler: function() {
    var id = $F("template_select");
    if (id == 0) {
      this.new_mode();
    } else {
      this.edit_mode("template_"+id);
    }
  },

  edit_handler: function() {
    var button = (this.mode == "edit") ? "template_window_save" : "template_window_new";

    var color = $F("template_window_color");
    if (is_valid_color(color)) {
      $("template_window_area").style.backgroundColor = color;
      $(button).disabled = false;
    } else {
      $(button).disabled = true;
    }
  },

  create_template: function() {
    var name    = $F("template_window_name");
    var color   = $F("template_window_color");
    var content = $F("template_window_area");
    MemoTemplate.create(name, color, content);
  },

  update_template: function() {
  },

  delete_template: function() {
    if (confirm("「#{name}」を削除します。この操作は元に戻せません。".interpolate({name:MemoTemplate.find(this.template_id).name}))) {
      MemoTemplate.destroy(this.template_id);
      this.destroy(this.template_id);
    }
  },

  destroy: function(template_id) {
    var idn = id_number(template_id);
    var elem = j$("#template_select option[@value=#{id}]".interpolate({id:idn}))[0];
    $(elem).remove();
    MemoTemplate.remove(template_id);
    if (this.template_id == template_id) {
      this.new_mode();
    }
  }
});

var MemoTemplate = Class.create({
  initialize: function(id, name, color, content) {
    this.elem_id = id;
    this.name = name;
    this.color = color;
    this.content = content;

    MemoTemplate.register(id, this);
  },

  save: function() {

  },

  id_number: function() {
    return id_number(this.elem_id);
  }
});

MemoTemplate.create = function(name, color, content)
{
  new Ajax.Request('/templates/create/', {parameters: {"memo[name]": name, "memo[color]": color, "memo[content]": content}});
};

MemoTemplate.destroy = function(template_id)
{
  new Ajax.Request('/templates/delete/'+id_number(template_id));
};

Object.extend(MemoTemplate, ObjectPool);
