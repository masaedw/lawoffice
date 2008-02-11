//------------------------------------------------------------
// ノートパッド機能
//

var Notepad = new Object;

Object.extend(Notepad, {
  init: function() {
    Notepad.resizing = new ResizingTextArea('notepad_area');
    Notepad.draggable = new Draggable('notepad', {scroll: document.body});
    Notepad.observer = new Form.Element.Observer('notepad_area', 2, function(element, value) {
      Notepad.update(value);
    }.bind(this));

    Notepad.draggable.exclude("notepad_box");

    Notepad.resize();
  },

  resize: function() {
    Notepad.resizing.resize('notepad_area');
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
