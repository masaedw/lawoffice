var memo_window = null;

var MemoWindow = new Object;

Object.extend(MemoWindow, {
  init: function() {
    memo_window = this;
    this.search_observer = new Form.Element.Observer("memo_window_search", 1, function(element, value) {
      memo_window.query = value;
      memo_window.page();
    }.bind(window));
    this.draggable = new Draggable('memo_window');
    Element.hide('memo_window');

    this.date_observer = new Form.Observer("memo_window_date",  1.5, function(element, value) {memo_window.date_handler();});
    Element.observe("memo_template_select", "change", function(event) {
      memo_window.template_select_handler(event);
    }.bindAsEventListener(window));
  },

  open: function(id, callback) {
    if (Object.isFunction(memo_window.callback)) {
      memo_window.callback();
      delete memo_window.callback;
    }
    memo_window = this;
    this.person_id = id;
    this.unchecked = true;
    this.query = "";
    this.date = $H();
    this.callback = callback;

    $('memo_window_name').update(Person.find(id).name());
    this.clear_display();
    this.clear_search();

    this.page();
    this.show_mode();
    $('memo_mode').setValue(1);
    $('memo_window').show().popup();
  },

  close: function(id) {
    Element.hide('memo_window');
    this.clear_display();
    this.clear_search();
    if (this.callback) {
      this.callback();
      delete this.callback;
    }
  },

  clear_display: function() {
    MemoDisplay.pool().invoke('clear');
    $('memo_paginate').update('');
  },

  clear_search: function() {
    $('memo_window_search').value = "";
    MemoWindow.search_observer.updateLastValue();
    this.query = "";
    var date = new Date;
    $("memo_window_year").value  = date.getFullYear();
    $("memo_window_month").value = date.getMonth()+1;
    $("memo_window_day").value   = date.getDate();
    $("memo_window_date_enable").checked = false;
    MemoWindow.date_observer.updateLastValue();
  },

  mode_handler: function() {
    switch($F('memo_mode')) {
      case '1': this.show_mode(); break;
      case '2': this.new_mode();  break;
    }
  },

  show_mode: function() {
    $("memo_window_unchecked").checked = true;
    $('memo_window_show').show();
    $('memo_window_display').show();
    $('memo_window_new').hide();
    $('memo_window_template').hide();
  },

  new_mode: function() {
    $('memo_window_show').hide();
    $('memo_window_display').hide();
    $('memo_window_new').show();
    $('memo_window_template').show();
  },

  create_memo: function() {
    // clear_new_forms の先に値を取得しておかなければいけない
    var content = $F('memo_window_new_area');
    var template_id = $F('memo_template_select');

    $('memo_mode').setValue(1);

    this.clear_display(); /* Memo.create の先でなければいけない */
    this.clear_search();
    this.clear_new_forms();
    this.show_mode();

    // create のレスポンスで memo_window_display が書き替わるので、
    // Memo.create の呼びだしは clear_display の後でなければいけない。
    this.controller.create(content, template_id);
    Person.update_unread(this.person_id, Person.find(this.person_id).unread()+1);
  },

  clear_new_forms: function() {
    $('memo_window_new_area').setValue("");
    $('memo_window_new_area').setStyle({backgroundColor: "#fff"});
    $('memo_template_select').setValue(0);
  },

  page: function(n) {
    if (Object.isUndefined(n)) n = 1;
//     if (MemoDisplay.pool().pluck("changed").any() &&
//         confirm("まだ保存されていない伝言がありますが、破棄されます。") == false)
//       return;
    var params = $H({page: n, unread: this.unchecked, query: this.query});
    if ($("memo_window_date_enable").checked)
      params.update(this.date);
    new Ajax.Request('/memos/view/#{person_id}?#{params}'.interpolate({person_id: id_number(this.person_id), params: params.toQueryString()}));
  },

  unchecked_set: function(param) {
    this.unchecked = param;
    this.page();
  },

  date_handler: function() {
    var year  = $F('memo_window_year');
    var month = $F('memo_window_month');
    var day   = $F('memo_window_day');
    function X(x){return parseInt(x) || "";}

    this.date = $H({year: X(year), month: X(month), day: X(day)});
    this.page();
  },

  date_set: function(date) {
    $("memo_window_year").value  = date.getFullYear();
    $("memo_window_month").value = date.getMonth()+1;
    $("memo_window_day").value   = date.getDate();
    MemoWindow.date_observer.updateLastValue();
    this.date_handler();
  },

  date_add: function(addend) {
    var year  = $F('memo_window_year');
    var month = $F('memo_window_month');
    var day   = $F('memo_window_day');
    var date  = new Date(parseInt(year), parseInt(month)-1, parseInt(day));
    if (isNaN(date.getFullYear()))
      return;
    this.date_set(new Date(date.getFullYear(), date.getMonth(), date.getDate()+addend));
  },

  next_date: function() {
    this.date_add(1);
  },

  prev_date: function() {
    this.date_add(-1);
  },

  template_select_handler: function(event) {
    var value = $F("memo_template_select");
    if (value == 0) {
      $("memo_window_new_area").setValue("");
      $("memo_window_new_area").setStyle({backgroundColor: "#fff"});
    } else {
      var template = MemoTemplate.find("template_"+value);
      $("memo_window_new_area").setValue(template.content);
      $("memo_window_new_area").setStyle({backgroundColor: template.color});
    }
  }
});


var Memo = new Object;

Object.extend(Memo, {
  create: function(content, template_id) {
    var person_id = id_number(MemoWindow.person_id);
    new Ajax.Request('/memos/create/'+person_id, {parameters: {"content": content, "template": template_id, unread: true}});
  },

  update_checked: function(display_id, memo_id, checked) {
    var person_id = MemoWindow.person_id;
    if (checked) {
      var diff = -1;
      var method = "check/"
    } else {
      var diff = 1;
      var method = "reset/"
    }
    Person.update_unread(person_id, Person.find(person_id).unread()+diff);
    new Ajax.Request('/memos/'+method+id_number(memo_id));
  },

  print_url: function(id) {
    return "/memos/print/"+id_number(id);
  },

  update: function(memo_id, display_id) {
    new Ajax.Request('/memos/update/'+id_number(memo_id), {parameters: {"content": $F(display_id+"_area")}});
  },

  display: function(display_id, params) {
    $(display_id+"_area").value = params.content;

    j$("#"+display_id+" .date").html(params.date);
    $(display_id+"_area").style.backgroundColor = params.color;
    $(display_id+"_check").checked = params.checked;
    $(display_id).down("a").writeAttribute("href", memo_window.controller.print_url(params.id));
    $(display_id).down(".footer span").update("確認済み");
    $(display_id).down(".dest_list").hide();
  }
});

MemoWindow.controller = Memo;

var MemoDisplay = Class.create();

Object.extend(MemoDisplay, ObjectPool);

MemoDisplay.prototype = {
  initialize: function(id) {
    this.elem_id = id;
    this.memo_id = null;
    this.changed = false;

    Event.observe(id+"_button", "click", function(e) {
      memo_window.controller.update(this.memo_id, id);
      this.changed = false;
      Effect.Fade(this.elem_id+"_button");
    }.bindAsEventListener(this));

    Event.observe(id+"_check", "change", function(e) {
      memo_window.controller.update_checked(id, this.memo_id, Event.element(e).checked);
    }.bindAsEventListener(this));

    this.observer = new Form.Element.Observer(id+"_area", 1, function(element, value) {
      if (!$(id+"_button").visible()) {
        this.changed = true;
        Effect.Appear(id+"_button");
      }
    }.bind(this));

    MemoDisplay.register(id, this);
  },

  display: function(params) {
    this.memo_id = params.id;
    memo_window.controller.display(this.elem_id, params);
    this.observer.updateLastValue();
    $(this.elem_id).show();
  },

  clear: function() {
    this.changed = false;
    this.memo_id = null;
    $(this.elem_id).hide();
    $(this.elem_id+"_button").hide();
  }
};


var BBSWindow = new Object;
Object.extend(BBSWindow, MemoWindow);
Object.extend(BBSWindow, {
  open: function() {
    if (Object.isFunction(memo_window.callback)) {
      memo_window.callback();
      delete memo_window.callback;
    }
    memo_window = this;
    this.person_id = "";
    this.unchecked = true;
    this.query = "";
    this.date = $H();
    this.callback = null;

    $('memo_window_name').update("回覧掲示板");
    this.clear_display();
    this.clear_search();

    this.page();
    this.show_mode();
    $('memo_mode').setValue(1);
    $('memo_window').show().popup();
  },

  page: function(n) {
    if (Object.isUndefined(n)) n = 1;
//     if (MemoDisplay.pool().pluck("changed").any() &&
//         confirm("まだ保存されていない伝言がありますが、破棄されます。") == false)
//       return;
    var params = $H({page: n, unread: this.unchecked, query: this.query});
    if ($("memo_window_date_enable").checked)
      params.update(this.date);
    new Ajax.Request('/bbs_memos/view/', {parameters: params});
  }
});


var BBSMemo = new Object;

Object.extend(BBSMemo, {
  create: function(content, template_id) {
    new Ajax.Request('/bbs_memos/create/', {parameters: {"content": content, "template": template_id, unread: true}});
  },

  update_checked: function(display_id, memo_id, checked) {
    new Ajax.Request('/bbs_memos/check_or_reset/'+id_number(memo_id), {parameters: {flag:checked}});
  },

  print_url: function(id) {
    return "/bbs_memos/print/"+id_number(id);
  },

  update: function(memo_id, display_id) {
    new Ajax.Request('/bbs_memos/update/'+id_number(memo_id), {parameters: {"content": $F(display_id+"_area")}});
  },

  display: function(display_id, params) {
    function tag(tag, content) {
      if (Object.isArray(content))
        content = content.join("");
      return "<#{tag}>#{content}</#{tag}>".interpolate({tag:tag, content:content||""});
    }
    function to_td(dest) {
      if (dest) {
        var c = {name:dest.name.escapeHTML(), checked:(dest.checked)?"checked=\"checked\"":"",
                 mid:params.id, pid:dest.id, did:display_id};
        return tag("td", "#{name}<input value=\"true\" type=\"checkbox\"#{checked}/ onchange=\"BBSMemo.update_person_checked('#{did}', '#{mid}', '#{pid}', this);\">".interpolate(c));
      } else {
        return tag("td");
      }
    }
    $(display_id+"_area").value = params.content;

    j$("#"+display_id+" .date").html(params.date);
    $(display_id+"_area").style.backgroundColor = params.color;
    $(display_id+"_check").checked = params.checked;
    $(display_id).down("a").writeAttribute("href", memo_window.controller.print_url(params.id));
    $(display_id).down(".footer span").update("最終確認済み");
    var trs = params.dests.inGroupsOf(3).map(function(i){return tag("tr", i.map(to_td));}).join("");
    $(display_id).down(".dest_list table").update(trs);
    if (!params.dests.all(function(i){return i.checked;})) {
        $(display_id+"_check").disable();
    } else {
        $(display_id+"_check").enable();
    }
    $(display_id).down(".dest_list").show();
  },

  update_person_checked: function(display_id, memo_id, person_id, element)
  {
    var val = $F(element);
    if (val == "true")
      var diff = -1;
    else
      var diff = 1;
    Person.update_bbs_unread(person_id, Person.find(person_id).bbs_unread()+diff);
    new Ajax.Request('/bbs_memos/person_check_or_reset/'+id_number(memo_id), {parameters: {"flag": val, "person_id": id_number(person_id)}});
    if ($A(j$("#"+display_id+" .dest_list input")).pluck("checked").all()) {
      $(display_id+"_check").enable();
    } else {
      $(display_id+"_check").disable().checked = false;
    }
  }
});

BBSWindow.controller = BBSMemo;
