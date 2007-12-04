var MemoWindow = new Object;

Object.extend(MemoWindow, {
  open: function(id) {
    this.person_id = id;

    j$("#memo_window_name").html(Person.find(id).name());
    j$("#memo_window_display").html("");

    this.update_display();
    this.show_mode();
    j$('#memo_mode option[@value=1]')[0].checked = true;
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
  },

  date_mode: function() {
    $('memo_window_show').hide();
    $('memo_window_date').show();
    $('memo_window_display').show();
    $('memo_window_new').hide();
  },

  new_mode: function() {
    $('memo_window_show').hide();
    $('memo_window_date').hide();
    $('memo_window_display').hide();
    $('memo_window_new').show();
  }
});
