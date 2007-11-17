var Person = Class.create();

Person.prototype = {
  initialize: function(elem) {
    var elem = $(elem);
    this.elem_id = elem.id;

    this.window = new Window(elem)
    this.window.onfocus = this.focus_handler.bindAsEventListener(this);
    this.window.onunfocus = this.unfocus_handler.bindAsEventListener(this);

    this.minimize();
  },

  focus_handler: function(event) {
    this.maximize();
    console.log("focus: "+this.elem_id);
  },

  unfocus_handler: function(event) {
    this.minimize();
    console.log("unfocus: "+this.elem_id);
  },

  maximize: function() {
    $(this.elem_id+"_mini").hide();
    $(this.elem_id+"_standard").show();
  },

  minimize: function() {
    $(this.elem_id+"_standard").hide();
    $(this.elem_id+"_mini").show();
  },
};
