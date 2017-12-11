document.addEventListener("turbolinks:before-cache", function() {
  $('.overlay, .side-nav').hide();
  $('.modal').modal('hide');
})
