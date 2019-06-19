import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['body', 'trigger'];

  connect() {
    // this.close()
  }

  toggle() {
    this.bodyTarget.classList.toggle('navigation-dropdown-menu--opened')
  }

  close() {
    if (event.target !== this.triggerTarget) {
      this.bodyTarget.classList.remove('navigation-dropdown-menu--opened')
    }
  }
}
