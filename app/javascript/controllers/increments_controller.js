import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['display', 'input'];

  decrement(event) {
    this.updateNumberAttribute({
      updateValue: -1,
      min: this.data.get('min'),
      input: this.inputTarget,
      targets: this.displayTargets,
      event
    });
  }

  increment(event) {
    this.updateNumberAttribute({
      max: this.data.get('max'),
      input: this.inputTarget,
      targets: this.displayTargets,
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
