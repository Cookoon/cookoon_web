import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['div'];

  connect() {
    const imageUrl = this.divTarget.getAttribute('data-image');
    const styleToApply = `background-image: url('${imageUrl}'); background-size: cover;`;
    this.divTarget.setAttribute('style', styleToApply);
  }
}
