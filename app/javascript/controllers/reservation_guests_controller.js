import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    $(':checked')
      .closest('.checkbox')
      .hide();
  }
}
