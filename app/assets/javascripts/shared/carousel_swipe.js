$(document).on('turbolinks:load ajaxComplete', function() {
  $('.carousel')
    .hammer()
    .bind('swipeleft', function() {
      $(this).carousel('next');
    });

  $('.carousel')
    .hammer()
    .bind('swiperight', function() {
      $(this).carousel('prev');
    });
});
