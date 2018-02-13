$(document).on('turbolinks:load ajaxComplete', function() {
  $('#guest a.add_fields')
    .data('association-insertion-position', 'before')
    .data('association-insertion-node', 'this');

  $('#guest').bind('cocoon:after-insert', function() {
    $('#guest_from_list').hide();
    $('#guest a.add_fields').hide();
  });
  $('#guest').bind('cocoon:after-remove', function() {
    $('#guest_from_list').show();
    $('#guest a.add_fields').show();
  });
});
