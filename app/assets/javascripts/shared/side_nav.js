$(document).on('turbolinks:load ajaxComplete', function() {
  $('#side-nav-clicker').click(function() {
    $('.overlay').fadeIn();
    $('.side-nav').show('slide', { direction: 'left' }, 500);
  });

  $('#side-nav-closer, .overlay').click(function() {
    $('.overlay').fadeOut();
    $('.side-nav').hide('slide', { direction: 'left' }, 500);
  });
});
