var TemplateWindow = new Object;

Object.extend(TemplateWindow, {
  init: function() {
    new Draggable("template_window");
    Event.observe("template_select", "change", function(){TemplateWindow.select_handler();});
    this.template_observer = new Form.Observer("template_window_form",  1.5, function(element, value) {TemplateWindow.edit_handler();});
  },

  open: function(id) {
    this.new_mode();
    $("template_select_none").selected = true;
    Element.show("template_window");
  },

  close: function(id) {
    Element.hide("template_window");
  },

  new_mode: function() {
    $("template_window_new").show();
    $("template_window_save").hide();
    $("template_window_delete").hide();
    this.show(null);
  },

  edit_mode: function() {
    $("template_window_new").hide();
    $("template_window_save").show();
    $("template_window_save").disabled = true;
    $("template_window_delete").show();
  },

  show: function(template) {
    if (!template)
      template = {name: "", color: "#fff", content :""};
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
      this.edit_mode();
      this.show(MemoTemplate.find("template_"+id));
    }
  },

  edit_handler: function() {
    $("template_window_save").disabled = false;
  }
});

var MemoTemplate = Class.create({
  initialize: function(id, name, color, content) {
    this.name = name;
    this.color = color;
    this.content = content;

    MemoTemplate.register(id, this);
  }
});

Object.extend(MemoTemplate, ObjectPool);
