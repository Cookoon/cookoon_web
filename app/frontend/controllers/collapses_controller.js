import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['body', 'trigger'];

  toggle() {
    event.preventDefault();
    this.bodyTarget.classList.toggle('collapsed')
  }
}
