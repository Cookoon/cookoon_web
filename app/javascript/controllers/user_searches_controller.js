import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [
    'address',
    'addressClear',
    'addressInput',
    'body',
    'date',
    'dateInput',
    'duration',
    'durationInput',
    'people',
    'peopleInput'
  ];

  connect() {
    this.updateAddressAndClearVisibility();
  }

  toggleBodyVisibility() {
    $(this.bodyTarget).slideToggle();
  }

  clearAddress() {
    this.addressInputTarget.value = '';
    this.updateAddressAndClearVisibility();
    this.addressInputTarget.focus();
  }

  updateAddressAndClearVisibility() {
    if (this.addressInputTarget.value) {
      this.addressClearTarget.classList.add('d-initial');
    } else {
      this.addressTarget.textContent = 'Adresse';
      this.addressClearTarget.classList.remove('d-initial');
    }
  }

  updateDateTarget() {
    this.dateTarget.textContent = this.dateInputTarget.value;
  }

  decrementDuration(event) {
    this.updateNumberAttribute({
      updateValue: -1,
      min: this.data.get('minDuration'),
      input: this.durationInputTarget,
      targets: this.durationTargets,
      event
    });
  }

  incrementDuration(event) {
    this.updateNumberAttribute({
      max: this.data.get('maxDuration'),
      input: this.durationInputTarget,
      targets: this.durationTargets,
      event
    });
  }

  decrementPeople(event) {
    this.updateNumberAttribute({
      updateValue: -1,
      min: this.data.get('minPeople'),
      input: this.peopleInputTarget,
      targets: this.peopleTargets,
      event
    });
  }

  incrementPeople(event) {
    this.updateNumberAttribute({
      max: this.data.get('maxPeople'),
      input: this.peopleInputTarget,
      targets: this.peopleTargets,
      event
    });
  }

  updateNumberAttribute(params) {
    params.updateValue = params.updateValue || 1;
    params.inputValue = parseInt(params.input.value);

    if (
      (!params.min && !params.max) ||
      (params.min && params.inputValue > parseInt(params.min)) ||
      (params.max && params.inputValue < parseInt(params.max))
    ) {
      params.input.value = params.inputValue + params.updateValue;
      params.targets.forEach(function(target) {
        target.textContent = params.input.value;
      });
      this.bump(params.event.currentTarget);
    }
  }

  bump(element) {
    element.classList.add('bump');
    setTimeout(function() {
      element.classList.remove('bump');
    }, 400);
  }
}
