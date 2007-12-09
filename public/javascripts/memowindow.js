var MemoWindow = new Object;

Object.extend(MemoWindow, {
  open: function(id) {
    this.person_id = id;
    this.unchecked = true;

    j$("#memo_window_name").html(Person.find(id).name());
    this.clear_display();

    this.page();
    this.show_mode();
    j$('#memo_mode option[@value=1]')[0].selected = true;
    $('memo_window').show().popup();
  },

  close: function(id) {
    Element.hide('memo_window');
    this.clear_display();
  },

  clear_display: function() {
    MemoDisplay.pool().invoke('clear');
    $('memo_paginate').update('');
  },

  mode_handler: function() {
    switch($F('memo_mode')) {
      case '1': this.show_mode(); break;
      case '2': this.date_mode(); break;
      case '3': this.new_mode();  break;
    }
  },

  show_mode: function() {
    $("memo_window_unchecked").checked = true;
    $('memo_window_show').show();
    $('memo_window_date').hide();
    $('memo_window_display').show();
    $('memo_window_new').hide();
    $('memo_window_template').hide();
  },

  date_mode: function() {
    $('memo_window_show').hide();
    $('memo_window_date').show();
    $('memo_window_display').show();
    $('memo_window_new').hide();
    $('memo_window_template').hide();
  },

  new_mode: function() {
    $('memo_window_show').hide();
    $('memo_window_date').hide();
    $('memo_window_display').hide();
    $('memo_window_new').show();
    $('memo_window_template').show();
  },

  create_memo: function() {
    // clear_new_forms の先に値を取得しておかなければいけない
    var content = $F('memo_window_new_area');
    var template_id = $F('memo_template_select');

    j$('#memo_mode option[@value=1]')[0].selected = true;

    this.clear_display(); /* Memo.create の先でなければいけない */
    this.clear_new_forms();
    this.show_mode();

    // create のレスポンスで memo_window_display が書き替わるので、
    // Memo.create の呼びだしは clear_display の後でなければいけない。
    Memo.create(id_number(this.person_id), content, template_id);
    Person.update_unread(this.person_id, Person.find(this.person_id).unread()+1);
  },

  clear_new_forms: function() {
    $('memo_window_new_area').value = "";
    j$('#memo_template_select option[@value=0]')[0].selected = true;
  },

  page: function(n) {
    if (Object.isUndefined(n)) n = 1;
//     if (MemoDisplay.pool().pluck("changed").any() &&
//         confirm("まだ保存されていない伝言がありますが、破棄されます。") == false)
//       return;
    var params = $H({page: n, unread: this.unchecked});
    new Ajax.Request('/memos/view/#{person_id}?#{params}'.interpolate({person_id: id_number(this.person_id), params: params.toQueryString()}));
  },

  unchecked_set: function(param) {
    this.unchecked = param;
    this.page();
  },
});


var Memo = new Object;

Object.extend(Memo, {
  create: function(person_id, content, template_id) {
    new Ajax.Request('/memos/create/'+person_id, {parameters: {"content": content, "template": template_id}});
  },

  update_checked: function(person_id, memo_id_number, checked) {
    if (checked) {
      var diff = -1;
      var method = "check/"
    } else {
      var diff = 1;
      var method = "reset/"
    }
    Person.update_unread(person_id, Person.find(person_id).unread()+diff);
    new Ajax.Request('/memos/'+method+memo_id_number);
  }
});


var MemoDisplay = Class.create();

Object.extend(MemoDisplay, ObjectPool);

MemoDisplay.prototype = {
  initialize: function(id) {
    this.elem_id = id;
    this.memo_id = null;
    this.changed = false;

    Event.observe(id+"_button", "click", function(e) {
      new Ajax.Request('/memos/update/'+id_number(this.memo_id), {parameters: {"content": $F(id+"_area")}});
      this.changed = false;
      Effect.Fade(this.elem_id+"_button");
    }.bindAsEventListener(this));

    Event.observe(id+"_check", "change", function(e) {
      Memo.update_checked(MemoWindow.person_id, id_number(this.memo_id), Event.element(e).checked);
    }.bindAsEventListener(this));

    this.observer = new Form.Element.Observer(id+"_area", 1, function(element, value) {
      if (!$(id+"_button").visible()) {
        this.changed = true;
        Effect.Appear(id+"_button");
      }
    }.bind(this));

    MemoDisplay.register(id, this);
  },

  display: function(id, date, content, color, read) {
    this.memo_id = id;
    $(this.elem_id+"_area").value = content;
    this.observer.updateLastValue();

    j$("#"+this.elem_id+" .date").html(date);
    $(this.elem_id+"_area").style.backgroundColor = color;
    $(this.elem_id+"_check").checked = read;
    $(this.elem_id).show();
  },

  clear: function() {
    this.changed = false;
    this.memo_id = null;
    $(this.elem_id).hide();
    $(this.elem_id+"_button").hide();
  }
};
