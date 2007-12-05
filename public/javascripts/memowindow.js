var MemoWindow = new Object;

Object.extend(MemoWindow, {
  open: function(id) {
    this.person_id = id;

    j$("#memo_window_name").html(Person.find(id).name());
    j$("#memo_window_display").html("");

    this.update_display();
    this.show_mode();
    j$('#memo_mode option[@value=1]')[0].selected = true;
    $('memo_window').show().popup();
  },

  update_display: function() {
    var idn = id_number(this.person_id);
    new Ajax.Updater('memo_window_display', '/memos/view/'+idn,
                     { asynchronous: true,
                       evalScripts:  true});
  },

  close: function(id) {
    Element.hide('memo_window');
    this.clear_display();
  },

  clear_display: function() {
    $('memo_window_display').update('');
  },

  mode_handler: function() {
    switch($F('memo_mode')) {
      case '1': this.show_mode(); break;
      case '2': this.date_mode(); break;
      case '3': this.new_mode();  break;
    }
  },

  show_mode: function() {
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
    Memo.create(id_number(this.person_id), $F('memo_window_new_area'), $F('memo_template_select'));
    j$('#memo_mode option[@value=1]')[0].selected = true;
    this.show_mode();
    $('memo_window_new_area').value = "";
    j$('#memo_template_select option[@value=0]')[0].selected = true;
    Person.update_unread(this.person_id, Person.find(this.person_id).unread()+1);
  }
});


var Memo = new Object;

Object.extend(Memo, {
  create: function(person_id, content, template_id) {
    new Ajax.Request('/memos/create/'+person_id,
                     { asynchronous: true,
                       evalScripts:  true,
                       parameters:   {"content": content, "template": template_id}});
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
    new Ajax.Request('/memos/'+method+memo_id_number, {asynchronous: true, evalScripts: true});
  }
});
