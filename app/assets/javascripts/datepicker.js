$(document).on('turbolinks:load ajaxComplete', function() {
  $('#user_search_date,#reservation_date').datetimepicker({
    autoclose: true,
    weekStart: 1,
    minuteStep: 30,
    format: 'd MM à h:ii',
    language: 'fr',
    startDate: new Date()
  });
});
