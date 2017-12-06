document.addEventListener("turbolinks:load", function() {
  // Show / Hide search
  $('.search-body').hide();
  $('.search-header').click(function() {
    $('.search-body').slideToggle();
  });

  // Fill header on change
  $('#user_search_date').change(function() {
    $('#infos-time-slot').text($(this).val());
  });

  $('#user_search_number').change(function() {
    $('#infos-number').text($(this).val());
  });

  // Listen click on control
  $('.control').click(function() {
    var clickedElem = $(this);
    bumpElement(clickedElem);
    modifyValue(clickedElem);
  });
})

function modifyValue(clickedElem) {
  var $input = $(clickedElem.parent().data('input'));
  var $field = $(clickedElem.parent().data('field'));
  var action = clickedElem.data('action');
  var min = $input.data("min");
  var max = $input.data("max");
  var value = parseInt($field.text(), 10);

  if ( action === "minus") {
    if ($input.val() > min) {
      value -= 1
      $field.text(value);
      $input.val(value);
    }
  }
  else if (action === "plus") {
    if ($input.val() < max) {
      value += 1
      $field.text(value);
      $input.val(value);
    }
  }
  $input.trigger("change");
}

// Make buttons bump
function bumpElement(clickedElem) {
  clickedElem.addClass("bump");
  setTimeout(function() {
    clickedElem.removeClass("bump");
  }, 400);
}
