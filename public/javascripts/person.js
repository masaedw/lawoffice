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

Person.update_unread = function(id, content)
{
  var unread = $(id).down(".mini .unread");
  if (content == 0)
    unread.hide();
  else
    unread.show();
  j$("#"+id+" .standard .unread").html("未読 "+content);
  console.log("update_unread: "+content);
  Person.update_text(id, "unread", content);
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
      this.draggable = new Draggable(id, {ghosting: true, snap: [5, 5]});

      // 名前と電話の変更を監視する
      this.name_phone_observer = new Form.Observer(id+'_form', 1, function(element, value) {
        new Ajax.Request('/people/update_text/'+this.id_number(), {parameters: value});
      }.bind(this));
    } else {
      this.minimize();

      // メッセージの変更を監視する
      this.message_observer = new Form.Element.Observer(id+'_message_input', 1, function(element, value) {
        new Ajax.Request('/people/update_message/'+this.id_number(), {parameters: 'message='+value});
      }.bind(this));

      // 場所変更を監視する
      this.select_observer = new Form.Element.EventObserver(id+'_select', function(element, value) {
        new Ajax.Request('/people/update_location/'+this.id_number(), {parameters: 'location='+value});
      }.bind(this));

      // マウスが来たら色替える。
      var default_border = "1px solid #888"
      var highlight_border = "1px solid yellow"

      Event.observe(id, "mouseover", function() {
        if (this.is_mini())
          $(id).style.border = highlight_border;
        else
          $(id).style.border = default_border;
      }.bindAsEventListener(this));

      Event.observe(id, "mouseout",  function() {
        $(id).style.border = default_border;
      }.bindAsEventListener(this));

      Event.observe($(id).down(".closebutton"), "click", this.minimize_handler.bindAsEventListener(this));
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
    this.mini__ = false;
    $(this.elem_id+"_mini").hide();
    $(this.elem_id+"_standard").show();
  },

  minimize: function()
  {
    this.mini__ = true;
    $(this.elem_id+"_standard").hide();
    $(this.elem_id+"_mini").show();
  },

  minimize_handler: function(event)
  {
    this.minimize();
    this.window.unfocus();
    Event.stop(event);
  },

  is_mini: function()
  {
    return this.mini__;
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
  },

  toString: function()
  {
    return "#<Person "+this.elem_id+">";
  },

  name: function()
  {
    return j$("#"+this.elem_id+" .mini .name").html();
  },

  unread: function()
  {
    return parseInt(j$("#"+this.elem_id+" .mini .unread").html()) || 0;
  }
};
