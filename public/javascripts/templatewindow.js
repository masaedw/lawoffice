var TemplateWindow = new Object;

Object.extend(TemplateWindow, {
  init: function() {
    new Draggable("template_window");
    Event.observe("template_select", "change", this.select_handler.bind(this));
    Event.observe("template_window_new",    "click", this.create_template.bind(this));
    Event.observe("template_window_save",   "click", this.update_template.bind(this));
    Event.observe("template_window_delete", "click", this.delete_template.bind(this));
    this.template_observer = new Form.Observer("template_window_form",  1.5, function(element, value) {TemplateWindow.edit_handler();});
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
    this.mode = "new";
    $("template_window_new").show();
    $("template_window_save").hide();
    $("template_window_delete").hide();
    this.show(null);
  },

  edit_mode: function() {
    this.mode = "edit";
    $("template_window_new").hide();
    $("template_window_save").show();
    $("template_window_save").disabled = true;
    $("template_window_delete").show();
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
    } else {
      this.edit_mode();
      this.show(MemoTemplate.find("template_"+id));
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

Object.extend(MemoTemplate, ObjectPool);
