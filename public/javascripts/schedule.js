var Schedule = new Object;

Object.extend(Schedule, {
  init: function() {
    if (edit_mode) {
      Event.observe("schedule_1", "change", function() {Schedule.update(1);});
      Event.observe("schedule_2", "change", function() {Schedule.update(2);});
    }
  },
  update: function(idn) {
    new Ajax.Request('/schedules/update/'+idn, {parameters: {body: $F("schedule_"+idn)}});
  },

  set: function(idn, body) {
    if (edit_mode) {
      $("schedule_"+idn).setValue(body);
    } else {
      $("schedule_"+idn).writeAttribute("href", body);
    }
  }
});
