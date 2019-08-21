import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['body', 'trigger'];

  toggle() {
    this.bodyTarget.classList.toggle('navigation-dropdown-menu--opened')
  }

  close() {
    if (!this.triggerTargets.includes(event.target)) {
      this.bodyTarget.classList.remove('navigation-dropdown-menu--opened')
    }
  }
}
