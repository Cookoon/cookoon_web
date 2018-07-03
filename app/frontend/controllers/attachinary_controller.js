import { Controller } from 'stimulus';
import 'jquery-ui';
import 'blueimp-file-upload';
import 'cloudinary-jquery-file-upload';
import 'vendor/attachinary';

export default class extends Controller {
  connect() {
    $('.attachinary-input').attachinary();

    // Display upload-zone if attachinary-input is not disabled
    if (!($('.attachinary-input')[0] && $('.attachinary-input')[0].disabled)) {
      $('label.attachinary').addClass('upload-zone');
    }

    // Remove upload-zone if last uploaded picture disables attachinary-input
    $('.attachinary-input').on('fileuploaddone', function(event) {
      if (event.result[0].disabled) {
        $('label.attachinary').removeClass('upload-zone');
      }
    });
  
    $(document).on('attachinary:fileremoved', function() {
      $('label.attachinary').addClass('upload-zone');
    })
  }
}
