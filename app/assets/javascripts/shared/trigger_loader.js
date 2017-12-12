$(document).on('turbolinks:load ajaxComplete', function() {
  $('.slowLoad').click(function() {
    $('#loader').show();
  });
});
