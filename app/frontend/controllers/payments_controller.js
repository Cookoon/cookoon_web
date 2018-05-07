import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = [
    'chargeAmount',
    'chargeAmountLabel',
    'discountButton',
    'discountInput',
    'userDiscountBalance',
    'userDiscountLabel',
    'servicesPrice'
  ];

  priceChanged() {
    this.fetchPaymentAmounts(this.data.get('discount'));
  }

  toggleDiscount() {
    this.fetchPaymentAmounts(!(this.data.get('discount') === 'true'));
  }

  fetchPaymentAmounts(discount) {
    const data = new FormData();
    data.append('payment[discount]', discount);

    Rails.ajax({
      url: this.data.get('amountsUrl'),
      type: 'post',
      data,
      success: response => {
        this.data.set('discount', response.discount);

        if (this.hasDiscountInputTarget) {
          this.discountInputTarget.value = response.discount;
        }

        this.render(response);
      },
      error: (_jqXHR, _textStatus, errorThrown) => {
        console.log(errorThrown);
      }
    });
  }

  render({
    discount,
    servicesPrice,
    _discountAmount,
    chargeAmount,
    userDiscountBalance
  }) {
    if (this.hasServicesPriceTarget) {
      this.servicesPriceTarget.textContent = servicesPrice;
    }
    this.chargeAmountTarget.textContent = chargeAmount;

    if (this.hasDiscountButtonTarget) {
      if (discount === 'true') {
        this.chargeAmountLabelTarget.textContent = 'TOTAL AVEC RÉDUCTION';
        this.discountButtonTarget.classList.add('payment-block-clicked');
        this.userDiscountLabelTarget.textContent = 'Nouveau Crédit';
      } else {
        this.chargeAmountLabelTarget.textContent = 'TOTAL';
        this.discountButtonTarget.classList.remove('payment-block-clicked');
        this.userDiscountLabelTarget.textContent = 'Crédit disponible';
      }
      this.userDiscountBalanceTarget.textContent = userDiscountBalance;
    }
  }
}
