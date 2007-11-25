var Person = Class.create();

Object.extend(Person, ObjectPool);

Person.update_text = function(id, klass, content)
{
  j$("span."+klass, $(id)).html(content);
  j$("input."+klass, $(id)).attr("value", content);
  if (!edit_mode)
    Person.find(id).message_observer.updateLastValue();
  else
    Person.find(id).name_phone_observer.updateLastValue();
};

Person.prototype = {
  initialize: function(id, edit)
  {
    this.elem_id = id;

    this.window = new Window(id);
    this.window.onfocus = this.focus_handler.bindAsEventListener(this);
    this.window.onunfocus = this.unfocus_handler.bindAsEventListener(this);

    if (edit) {
      this.edit = true;
      this.draggable = new Draggable(id);

      // 名前と電話の変更を監視する
      this.name_phone_observer = new Form.Observer(id+'_form', 1, function(element, value) {
        new Ajax.Request('/people/update_text/'+this.id_number(),
                         { asynchronous: true,
                           evalScripts:  true,
                           parameters:   value});
      }.bind(this));
    } else {
      this.minimize();

      // メッセージの変更を監視する
      this.message_observer = new Form.Element.Observer(id+'_message_input', 1, function(element, value) {
        new Ajax.Request('/people/update_message/'+this.id_number(),
                         { asynchronous: true,
                           evalScripts:  true,
                           parameters:   'message='+value});
      }.bind(this));

      // 場所変更を監視する
      this.select_observer = new Form.Element.EventObserver(id+'_select', function(element, value) {
        new Ajax.Request('/people/update_location/'+this.id_number(),
                         { asynchronous: true,
                           evalScripts:  true,
                           parameters:   'location='+value});
      }.bind(this));
    }

    Person.register(id, this);
  },

  id_number: function()
  {
    return this.elem_id.replace(/person_/, '');
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
  // 今は知らないので、location の id をもらう。
  //
  // id が null ならデフォルトに戻す。
  update_location: function(id)
  {
    if (id == null) {
      $(this.elem_id).style.backgroundColor = "#eceef0";
      j$("#"+this.elem_id+"_select").prepend("<option id=\""+this.elem_id+"_null_location\"></option>");
      if (!this.edit) {
        $(this.elem_id+"_null_location").selected = true;
        this.select_observer.updateLastValue();
      }
    } else {
      $(this.elem_id).style.backgroundColor = $(id).style.backgroundColor;
      j$("#"+this.elem_id+"_null_location").remove();

      var select = $(this.elem_id+"_select");
      if (select) {
        for (var i = 0; i < select.options.length; i++) {
          if (select.options[i].value == id.replace(/location_/,'')) {
            if (!select.options[i].selected == true) {
              select.options[i].selected = true;
              this.select_observer.updateLastValue();
            }
            return;
          }
        }
      }
    }
  }
};
