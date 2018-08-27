import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['infos']
  
  //   TODO FC/CP Try to improve this part without having partial as data-attributes
  displayPendingQuote() {
    this.infosTarget.innerHTML = JSON.parse(this.data.get('pending')).html
  }

  displayPersona() {
    this.infosTarget.innerHTML = JSON.parse(this.data.get('persona')).html
  }
}
