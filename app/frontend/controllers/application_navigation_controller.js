import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    $('.slowLoad').click(function() {
      $('#loader').show();
    });
  }
}
