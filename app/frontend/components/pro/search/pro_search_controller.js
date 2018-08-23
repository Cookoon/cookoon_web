import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    'durationSelection',
    'selection',
    'durationInput',
    'durationText',
    'countInput',
    'countText'
  ]

  connect() {
    this.displayFromInputs()
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
    const count = event.target.dataset.count
    this.countTextTarget.innerHTML = `${count} personnes`
    this.countInputTarget.value = count
  }

  selectDuration() {
    const duration = event.target.dataset.duration
    this.durationTextTarget.innerHTML = `${duration} heures`
    this.durationInputTarget.value = duration
  }

  displayFromInputs() {
    const count = this.countInputTarget.value
    if (count) { this.countTextTarget.innerHTML = `${count} personnes`  }

    const duration = this.durationInputTarget.value
    if (duration) { this.durationTextTarget.innerHTML = `${duration} heures` }
  }
}
