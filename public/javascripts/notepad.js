//------------------------------------------------------------
// ノートパッド機能
//

var Notepad = new Object;

Object.extend(Notepad, {
  resize_callback: function() {
    var width = $("notepad_area").getWidth();
    $("notepad").setStyle({"width": width+"px"});
  },

  resize: function() {
    Notepad.resizing.resize($("notepad_area"));
    Notepad.resize_callback();
  },

  init: function() {
    Notepad.resizing = new ResizingTextArea('notepad_area', Notepad.resize_callback);
    new Draggable('notepad', {scroll: document.body});
    Notepad.resize();
    Notepad.observer = new Form.Element.Observer('notepad_area', 2, function(element, value) {
      Notepad.update(value);
    }.bind(this));
  },

  set: function(content) {
    if (!edit_mode) {
      $("notepad_area").setValue(content);
      Notepad.observer.updateLastValue();
      Notepad.resize();
    }
  },

  update: function() {
    new Ajax.Request('/notepad_contents/update/', {parameters: {body: $F("notepad_area")}});
  }
});
