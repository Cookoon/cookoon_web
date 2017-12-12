$(document).on('turbolinks:load ajaxComplete', function() {
  $.cloudinary.responsive();
  if ($('.attachinary_container').size() === 0) {
    $('.attachinary-input').attachinary();
  }
});
