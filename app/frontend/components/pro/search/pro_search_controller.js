import { Controller } from "stimulus"
import flatpickr from 'vendor/flatpickr';

export default class extends Controller {
  static targets = [
    'selection',
    'durationInput',
    'durationText',
    'countInput',
    'countText',
    'dateSelection',
    'dateInput',
    'dateText'
  ]

  connect() {
    this.displayFromInputs()
    flatpickr(this.dateSelectionTarget, {
      dateFormat: 'Y-m-dTH:i',
      minDate: 'today',
      weekNumbers: true,
      enableTime: true,
      time_24hr: true,
      onValueUpdate: (selectedDates, dateStr, instance) => {
        this.selectDate(selectedDates, dateStr)
        console.log(dateStr)
      },
    });
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

  selectDate(selectedDates, dateStr) {
    const date = selectedDates[0]
    const options = {weekday: "short", year: "numeric", month: "long", day: "numeric", hour: "numeric", minute: "numeric"}
    this.dateTextTarget.innerHTML = date.toLocaleString('fr', options)

    this.dateInputTarget.value = dateStr;
  }

  displayFromInputs() {
    const count = this.countInputTarget.value
    if (count) { this.countTextTarget.innerHTML = `${count} personnes`  }

    const duration = this.durationInputTarget.value
    if (duration) { this.durationTextTarget.innerHTML = `${duration} heures` }
  }
}
