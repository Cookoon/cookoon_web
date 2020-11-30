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
    'dateInput',
    // Added by Alice
    'submitForm',
    'submitFormLogo'
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
      // disable: ["2020-11-30", "2020-12-09"],
      disable: JSON.parse(this.dateSelectionTarget.getAttribute("data-dates-unavailable")),
      // minDate: 'today',
      minDate: new Date().fp_incr(3),
      maxDate: this.dateSelectionTarget.getAttribute("data-end-date-available"),
      // not working if day is sunday
      // maxDate: (new Date().fp_incr(5*7)).fp_incr(-((new Date().fp_incr(5*7)).getDay())),
      disableMobile: "true",
      onValueUpdate: (selectedDates, dateStr) => {
        this.selectDate(selectedDates, dateStr)
      },
    })
  }

  toggleSelection() {
    const input = event.target.closest('.input-cookoon-search')
    input.querySelector('.input-cookoon-search-selection').classList.toggle('d-none')
    event.target.classList.toggle('focus')
  }

  hideSelections() {
    this.selectionTargets.forEach(element => {
      if (element !== event.target.closest('.input-cookoon-search')) {
        element.querySelector('.input-cookoon-search-selection').classList.add('d-none')
        element.classList.remove('focus')
      }
    })
  }

  selectCount() {
    const count = event.target.dataset.count
    this.countTextTarget.innerHTML = count
    this.countInputTarget.value = count
    event.target.closest('.input-cookoon-search').classList.remove('focus')
  }

  selectType() {
    const duration = event.target.dataset.type
    const text = event.target.dataset.text
    this.typeTextTarget.innerHTML = text
    this.typeInputTarget.value = duration
    event.target.closest('.input-cookoon-search').classList.remove('focus')
  }

  selectDate(selectedDates, dateStr) {
    this.dateTextTarget.innerHTML = selectedDates[0].toLocaleString('fr', this.constructor.dateOptions)
    this.dateInputTarget.value = dateStr
  }

  // Added by Alice: submit when clicking on the form (not only on the img)
  submitForm() {
    this.submitFormTarget.submit();
  }

  // Added by Alice to change background-color and img
  changeImageAndToggleBg(imagePath) {
    this.submitFormTarget.style = "transition-duration: 1s;"
    this.submitFormTarget.classList.toggle("bg-white");
    this.submitFormTarget.classList.toggle("bg-primary");
    this.submitFormLogoTarget.setAttribute("src", imagePath);
  }

  logoWhiteBackgroundBold() {
    const logo = this.submitFormLogoTarget.dataset.logoWhite;
    this.changeImageAndToggleBg(logo);
  }

  logoBoldBackgroundWhite() {
    const logo = this.submitFormLogoTarget.dataset.logoBold;
    this.changeImageAndToggleBg(logo);
  }
}
