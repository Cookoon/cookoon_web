$(document).on('turbolinks:load ajaxComplete', function() {
  $('.reservation-option').change(function() {
    compute_price_for_host($(this));
  });
});

function compute_price_for_host(input) {
  var displayPriceCents = parseInt(
    $('#display-price').data('reservation-price-cents'),
    10
  );
  var optionPriceCents = parseInt(input.data('price-cents'), 10);
  if (input.is(':checked')) {
    $('#display-price').text(
      ((displayPriceCents - optionPriceCents) / 100)
        .toFixed(2)
        .replace('.', ',') + ' €'
    );
    $('#display-price').data(
      'reservation-price-cents',
      displayPriceCents - optionPriceCents
    );
  } else {
    $('#display-price').text(
      ((displayPriceCents + optionPriceCents) / 100)
        .toFixed(2)
        .replace('.', ',') + ' €'
    );
    $('#display-price').data(
      'reservation-price-cents',
      displayPriceCents + optionPriceCents
    );
  }
}
