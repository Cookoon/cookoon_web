import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [
    'date',
    'dateInput',
    'duration',
    'durationInput',
    'people',
    'peopleInput'
  ];

  updateDateTarget() {
    this.dateTarget.innerHTML = this.dateInputTarget.value;
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
        target.innerHTML = params.input.value;
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
