import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['infos']

  displayPendingQuote() {
    this.infosTarget.innerHTML = JSON.parse(this.data.get('pending')).html
  }

  displayPersona() {
    this.infosTarget.innerHTML = JSON.parse(this.data.get('persona')).html
  }
}
