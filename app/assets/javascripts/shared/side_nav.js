$(document).on('turbolinks:load ajaxComplete', function() {
  $('.side-nav').slideAndSwipe();
});

document.addEventListener('turbolinks:before-cache', function() {
  $('.side-nav').css('transform', 'translate(-280px, 0px)');
  $('.ssm-overlay').hide();
  $('html').removeClass('is-navOpen');
  $('.side-nav').removeClass('ssm-nav-visible');
});
