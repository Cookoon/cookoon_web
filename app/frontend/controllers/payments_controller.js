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
    console.log('priceChanged');
  }

  toggleDiscount() {
    const data = new FormData();
    data.append('payment[discount]', !(this.data.get('discount') === 'true'));

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

  render({ discount, _discountAmount, chargeAmount, userDiscountBalance }) {
    this.discountInputTarget.value = discount;
    this.data.set('discount', discount);
    if (discount === 'true') {
      this.discountButtonTarget.classList.add('payment-block-clicked');
      this.chargeAmountLabelTarget.textContent = 'TOTAL AVEC RÉDUCTION';
      this.userDiscountLabelTarget.textContent = 'Nouveau Crédit';
    } else {
      this.discountButtonTarget.classList.remove('payment-block-clicked');
      this.chargeAmountLabelTarget.textContent = 'TOTAL';
      this.userDiscountLabelTarget.textContent = 'Crédit disponible';
    }
    this.chargeAmountTarget.textContent = chargeAmount;
    this.userDiscountBalanceTarget.textContent = userDiscountBalance;
  }
}
