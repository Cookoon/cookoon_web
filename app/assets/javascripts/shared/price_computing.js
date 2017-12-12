$(document).on('turbolinks:load ajaxComplete', function() {
  $('.reservation-option').change(function() {
    compute_price_for_host($(this));
  });

  $('#reservation_duration').change(function() {
    compute_price_for_rent($(this));
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

function compute_price_for_rent(duration_input) {
  var price_cents_without_fees =
    $('#cookoon-price').data('cookoon-price-cents') * duration_input.val();
  var total_price_cents = price_cents_without_fees * 1.05;
  $('#total-price').text(
    (total_price_cents / 100).toFixed(2).replace('.', ',') + ' €'
  );
}
