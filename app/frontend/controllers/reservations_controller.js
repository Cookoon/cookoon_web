import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['displayPrice', 'duration', 'durationInput'];

  updatePrice() {
    const price_cents =
      this.data.get('cookoonPriceCents') * this.durationInputTarget.value;
    const price_with_tenant_fee_cents = price_cents * 1.05;
    this.renderPrice(price_with_tenant_fee_cents);
  }

  renderPrice(price_cents) {
    const displayPrice = `${(price_cents / 100)
      .toFixed(2)
      .replace('.', ',')} €`;
    this.displayPriceTarget.textContent = displayPrice;
  }

  decrementDuration(event) {
    this.updateNumberAttribute({
      updateValue: -1,
      min: this.data.get('minDuration'),
      input: this.durationInputTarget,
      targets: this.durationTargets,
      event
    });
    this.updatePrice();
  }

  incrementDuration(event) {
    this.updateNumberAttribute({
      max: this.data.get('maxDuration'),
      input: this.durationInputTarget,
      targets: this.durationTargets,
      event
    });
    this.updatePrice();
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
