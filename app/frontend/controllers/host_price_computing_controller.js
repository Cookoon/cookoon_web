import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['displayPrice'];

  connect() {
    this.reservationPriceCents = parseInt(
      this.data.get('reservationPriceCents'),
      10
    );
    this.servicePriceCents = parseInt(this.data.get('servicePriceCents'), 10);
  }

  updatePrice({ target }) {
    if (target.checked) {
      this.reservationPriceCents =
        this.reservationPriceCents - this.servicePriceCents;
    } else {
      this.reservationPriceCents =
        this.reservationPriceCents + this.servicePriceCents;
    }

    this.renderPrice();
  }

  renderPrice() {
    this.data.set('reservationPriceCents', this.reservationPriceCents);

    this.displayPriceTarget.textContent =
      (this.reservationPriceCents / 100).toFixed(2).replace('.', ',') + ' €';
  }
}
