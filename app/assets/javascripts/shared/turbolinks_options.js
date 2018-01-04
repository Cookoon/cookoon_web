document.addEventListener('turbolinks:before-cache', function() {
  $('.overlay, .side-nav').hide();
  $('.modal').modal('hide');
})

// Make sure to empty all flashes before every visit, before-cache is not enough
document.addEventListener('turbolinks:before-visit', function() {
  $('#flash').empty();
})
