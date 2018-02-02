$(document).on('turbolinks:load ajaxComplete', function() {
  // Show / Hide search
  $('.search-body').hide();
  $('.search-header-clickable').click(function() {
    $('.search-body').slideToggle();
  });

  // Address search clear button
  $('#user_search_address').keyup(function() {
    $('#user_search_address_clear').toggle(Boolean($(this).val()));
  });
  $('#user_search_address_clear').toggle(
    Boolean($('#user_search_address').val())
  );
  $('#user_search_address_clear').click(function() {
    $('#infos-address').text('Adresse');
    $('#user_search_address')
      .val('')
      .focus();
    $(this).hide();
  });
});
