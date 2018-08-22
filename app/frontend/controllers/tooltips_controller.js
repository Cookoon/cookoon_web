import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['tooltip']

  connect() {
    $(this.tooltipTarget).tooltip()
  }

  disconnect() {
    $(this.tooltipTarget).tooltip('dispose')
  }
}
