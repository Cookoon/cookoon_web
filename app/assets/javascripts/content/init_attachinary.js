document.addEventListener("turbolinks:load", function() {
  $.cloudinary.responsive();
  if ($('.attachinary_container').size() === 0) { $('.attachinary-input').attachinary() };
});
