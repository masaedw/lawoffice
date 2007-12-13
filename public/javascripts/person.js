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

Person.update_bbs_unread = function(id, content)
{
  Person.update_text(id, "bbs_unread", content);
  $(id).down(".standard .bbs_unread").update("回覧 "+content);
};

Person.prototype = {
  initialize: function(id, edit)
  {
    this.elem_id = id;

    this.window = new Window(id);
    this.window.onfocus = this.focus_handler.bindAsEventListener(this);
    this.window.onunfocus = this.unfocus_handler.bindAsEventListener(this);
    this.memo_window_open = false;

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
      Event.observe(id, "mouseover", function() {
        if (this.is_memo_window_open()) return;
        if (this.is_mini())
          this.highlight(true);
        else
          this.highlight(false);
      }.bindAsEventListener(this));

      Event.observe(id, "mouseout",  function() {
        if (this.is_memo_window_open()) return;
        this.highlight(false);
      }.bindAsEventListener(this));

      Event.observe($(id).down(".closebutton"), "click", this.minimize_handler.bindAsEventListener(this));
      Event.observe($(id).down("a.unread"), "click", this.open_memo_window_handler.bindAsEventListener(this));
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

  is_memo_window_open: function()
  {
    return this.memo_window_open;
  },

  open_memo_window_handler: function(event)
  {
    this.minimize_handler(event);
    this.memo_window_open = true;
    this.highlight(true);
    MemoWindow.open(this.elem_id, this.close_memo_window_handler.bind(this));
  },

  close_memo_window_handler: function(event)
  {
    this.memo_window_open = false;
    this.highlight(false);
  },

  highlight: function(flag)
  {
    var default_border = "1px solid #888"
    var highlight_border = "3px solid yellow"
    if (flag && !this.highlighted__) {
      $(this.elem_id).style.border = highlight_border;
      $(this.elem_id).style.top = parseInt($(this.elem_id).style.top) - 2 + "px"
      $(this.elem_id).style.left = parseInt($(this.elem_id).style.left) - 2 + "px"
      this.highlighted__ = true;
    } else if (!flag && this.highlighted__) {
      $(this.elem_id).style.border = default_border;
      $(this.elem_id).style.top = parseInt($(this.elem_id).style.top) + 2 + "px"
      $(this.elem_id).style.left = parseInt($(this.elem_id).style.left) + 2 + "px"
      this.highlighted__ = false;
    }
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
  },

  bbs_unread: function()
  {
    return parseInt(j$("#"+this.elem_id+" .mini .bbs_unread").html()) || 0;
  }
};
