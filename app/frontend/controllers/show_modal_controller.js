import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [
    'modalId'
  ]

  connect() {
    // $('#invited_successfully').modal('show');
    $('#' + this.modalIdTarget.id).modal('show');
  }
}
