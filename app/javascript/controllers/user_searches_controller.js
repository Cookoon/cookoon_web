import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['date', 'dateInput'];

  updateDateTarget() {
    this.dateTarget.innerHTML = this.dateInputTarget.value;
  }
}
