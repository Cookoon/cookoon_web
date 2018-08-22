import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'durationSelection',
    'selection',
    'durationInput',
    'countInput'
  ]

  connect() {
    console.log("Hello, Stimulus!", this.element)
  }

  toggleSelection() {
    event.target.querySelector('.pro-search-input-selection') &&
      event.target.querySelector('.pro-search-input-selection').classList.toggle('d-none')
  }

  hideSelections() {
    this.selectionTargets.forEach(element => {
      if (element !== event.target) {
        element.querySelector('.pro-search-input-selection').classList.add('d-none')
      }
    })
  }

  selectCount() {
    this.countInputTarget.value = event.target.dataset.count
  }

  selectDuration() {
    this.durationInputTarget.value = event.target.dataset.duration
  }
}
