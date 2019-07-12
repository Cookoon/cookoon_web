import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = [
    'chargeAmount',
    'chargeAmountLabel',
    'servicesPrices'
  ];

  priceChanged() {
    this.fetchPaymentAmounts();
  }

  fetchPaymentAmounts() {
    const data = new FormData();

    Rails.ajax({
      url: this.data.get('amountsUrl'),
      type: 'post',
      data,
      success: response => {
        this.render(response);
      },
      error: (_jqXHR, _textStatus, errorThrown) => {
        console.log(errorThrown);
      }
    });
  }

  render({
    chargeAmount,
    servicesCount,
    html
  }) {

    this.chargeAmountTarget.textContent = chargeAmount;

    if (this.hasServicesPricesTarget) {
      if (servicesCount === 0) {
        this.servicesPricesTarget.classList.add('d-none');
      } else {
        this.servicesPricesTarget.classList.remove('d-none');
      }

      this.servicesPricesTarget.innerHTML = html;
    }
  }
}
