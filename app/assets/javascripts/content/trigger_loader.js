document.addEventListener("turbolinks:load", function() {
  $('.slowLoad').click(function() {
    $('#loader').show();
  })
})
