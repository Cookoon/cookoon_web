$(document).on('turbolinks:load ajaxComplete', function() {
  $('.reservation-option').change(function() {
    compute_price_for_host($(this));
  });

  $('#reservation_duration').change(function() {
    compute_price_for_rent($(this));
  });
});

function compute_price_for_host(input) {
  var displayPrice = parseFloat(
    $('#display-price')
      .text()
      .replace(',', '.')
  );
  var optionPrice = input.data('price');
  if (input.is(':checked')) {
    $('#display-price').text(
      (displayPrice - optionPrice).toFixed(2).replace('.', ',')
    );
  } else {
    $('#display-price').text(
      (displayPrice + optionPrice).toFixed(2).replace('.', ',')
    );
  }
}

function compute_price_for_rent(duration_input) {
  var price_cents_without_fees =
    $('#cookoon-price')
      .text()
      .replace(',', '.') *
    duration_input.val() *
    100;
  var total_price_cents = price_cents_without_fees * 1.05;
  $('#total-price').text(
    (total_price_cents / 100).toFixed(2).replace('.', ',')
  );
}
