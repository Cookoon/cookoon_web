import { Controller } from 'stimulus';
import 'jquery-ui';
import 'blueimp-file-upload';
import 'cloudinary-jquery-file-upload';
import 'vendor/attachinary';

export default class extends Controller {
  connect() {
    $('.attachinary-input').attachinary();

    // Display upload-zone if attachinary-input is not disabled
    $('.attachinary-input').each(function() {
      if (!($(this)[0] && $(this)[0].disabled)) {
        $("label[for='"+$(this).attr('id')+"']").addClass('upload-zone');
      }
    });
    // Old code that was ok for only one attachinary input
    // if (!($('.attachinary-input')[0] && $('.attachinary-input')[0].disabled)) {
    //   $('label.attachinary').addClass('upload-zone');
    // }

    // Remove upload-zone if last uploaded picture disables attachinary-input
    $('.attachinary-input').each(function() {
      $(this).on('fileuploaddone', function(event) {
        if (event.result[0].disabled) {
          $("label[for='"+$(this).attr('id')+"']").removeClass('upload-zone');
        }
      });
    });
    // Old code that was ok for only one attachinary input
    // $('.attachinary-input').on('fileuploaddone', function(event) {
    //   if (event.result[0].disabled) {
    //     $('label.attachinary').removeClass('upload-zone');
    //   }
    // });

    // Add upload-zone if picture deleted
    $('.attachinary-input').each(function() {
      $(this).on('attachinary:fileremoved', function(event) {
        $("label[for='"+$(this).attr('id')+"']").addClass('upload-zone');
      });
    });
    // Old code that was ok for only one attachinary input
    // $(document).on('attachinary:fileremoved', function() {
    //   $('label.attachinary').addClass('upload-zone');
    // })
  }
}
