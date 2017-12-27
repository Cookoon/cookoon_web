$(document).on('turbolinks:load ajaxComplete', function() {
  $.cloudinary.responsive();
  if ($('.attachinary_container').size() === 0) {
    $('.attachinary-input').attachinary();

    // Display upload-zone if attachinary-input is not disabled
    if (!($('.attachinary-input')[0] && $('.attachinary-input')[0].disabled)) {
      $('label.attachinary').addClass('upload-zone');
    }
    // Remore upload-zone if last uploaded picture disables attachinary-input
    $('.attachinary-input').bind('fileuploaddone', function(event) {
      if (event.result.context.disabled) {
        $('label.attachinary').removeClass('upload-zone');
      }
    });
  }

  // Display upload-zone on image removal
  $('.attachinary_container a').click(function() {
    $('label.attachinary').addClass('upload-zone');
  });
});

$.attachinary.config.template =
  '\
    <% for(var i=0; i<files.length; i++){ %>\
      <div>\
        <% if(files[i].resource_type == "raw") { %>\
          <div class="raw-file"></div>\
        <% } else if (files[i].format == "mp3") { %>\
          <audio src="<%= $.cloudinary.url(files[i].public_id, { "version": files[i].version, "resource_type": "video", "format": "mp3"}) %>" controls />\
        <% } else { %>\
          <img\
            src="<%= $.cloudinary.url(files[i].public_id, { "version": files[i].version, "format": "jpg", "crop": "fill", "width": 240, "height": 180 }) %>"\
            alt="" width="240" height="180" />\
        <% } %>\
        <a href="#" data-remove="<%= files[i].public_id %>">×</a>\
      </div>\
    <% } %>\
';
