import { Controller } from 'stimulus';
import flatpickr from 'vendor/flatpickr';

export default class extends Controller {
  static targets = [
    'selection',
    'countText',
    'countInput',
    'typeText',
    'typeInput',
    'dateSelection',
    'dateText',
    'dateInput'
  ]

  static dateOptions = {
    weekday: "short",
    year: "numeric",
    month: "long",
    day: "numeric",
  }

  connect() {
    flatpickr(this.dateSelectionTarget, {
      dateFormat: 'Y-m-dTH:i',
      minDate: 'today',
      onValueUpdate: (selectedDates, dateStr) => {
        this.selectDate(selectedDates, dateStr)
      },
    })
  }

  toggleSelection() {
    const input = event.target.closest('.search-input')
    input.querySelector('.search-input-selection').classList.toggle('d-none')
    event.target.classList.toggle('focus')
  }

  hideSelections() {
    this.selectionTargets.forEach(element => {
      if (element !== event.target.closest('.search-input')) {
        element.querySelector('.search-input-selection').classList.add('d-none')
        element.classList.remove('focus')
      }
    })
  }

  selectCount() {
    const count = event.target.dataset.count
    this.countTextTarget.innerHTML = `${count} personnes`
    this.countInputTarget.value = count
    event.target.closest('.search-input').classList.remove('focus')
  }

  selectType() {
    const duration = event.target.dataset.type
    const text = event.target.dataset.text
    this.typeTextTarget.innerHTML = text
    this.typeInputTarget.value = duration
    event.target.closest('.search-input').classList.remove('focus')
  }

  selectDate(selectedDates, dateStr) {
    this.dateTextTarget.innerHTML = selectedDates[0].toLocaleString('fr', this.constructor.dateOptions)
    this.dateInputTarget.value = dateStr
  }
}
