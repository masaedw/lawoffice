var MemoWindow = new Object;

Object.extend(MemoWindow, {
  open: function(id) {
    var idn = id_number(id);
    new Ajax.Updater('memo_window_display', '/memos/view/'+idn,
                     { asynchronous: true,
                       evalScripts:  true});

    $('memo_window').show().popup();
  },

  close: function(id) {
    Element.hide('memo_window');
    this.clear_display();
  },

  clear_display: function() {
    $('memo_window_display').update('');
  }
});