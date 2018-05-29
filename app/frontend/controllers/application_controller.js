import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    $.cloudinary.config(JSON.parse(this.data.get('cloudinaryConfigParams')));

    // Turbolinks
    document.addEventListener('turbolinks:before-cache', function() {
      $('.modal').modal('hide');
    });
    // Make sure to empty all flashes before every visit, before-cache is not enough
    document.addEventListener('turbolinks:before-visit', function() {
      $('#flash').empty();
    });
  }
}
