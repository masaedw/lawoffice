var Person = Class.create();

Object.extend(Person, ObjectPool);

Person.update_text = function(id, klass, content)
{
  var elem = $(id);
  var elems = elem.getElementsByClassName(klass);
  var i;

  for (i = 0; i < elems.length; i++) {
    if (elems[i].tagName.toUpperCase() == "INPUT")
      elems[i].value = content;
    else
      elems[i].innerHTML = content;
  }
};

Person.prototype = {
  initialize: function(id, edit)
  {
    this.elem_id = id;

    this.window = new Window(id);
    this.window.onfocus = this.focus_handler.bindAsEventListener(this);
    this.window.onunfocus = this.unfocus_handler.bindAsEventListener(this);

    this.minimize();

    if (edit) {
      this.edit = true;
      this.draggable = new Draggable(id);
    } else {
      Event.observe(id+"_message_input", "change", function(event) {
        new Ajax.Request('/people/update_message/'+id.replace(/person_/, ''),
                         {asynchronous:true, evalScripts:true,
                          parameters:{message: $(id+"_message_input").value}});
      });
    }

    Person.register(id, this);
  },

  focus_handler: function(event)
  {
    if (!this.edit)
      this.maximize();
    console.log("focus: "+this.elem_id);
  },

  unfocus_handler: function(event)
  {
    if (!this.edit)
      this.minimize();
    console.log("unfocus: "+this.elem_id);
  },

  maximize: function()
  {
    $(this.elem_id+"_mini").hide();
    $(this.elem_id+"_standard").show();
  },

  minimize: function()
  {
    $(this.elem_id+"_standard").hide();
    $(this.elem_id+"_mini").show();
  },

  // person は自分の location を知っておくべきな気がする。
  // 今は知らないので、location の idをもらう。
  update_location: function(id)
  {
    $(this.elem_id).style.backgroundColor = $(id).style.backgroundColor;
  }
};
