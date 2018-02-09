import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = [
    'form',
    'accountError',
    'accountTokenInput',
    'firstNameInput',
    'lastNameInput',
    'addressInput',
    'postalCodeInput',
    'cityInput'
  ];

  stripe = Stripe(process.env.STRIPE_PUBLISHABLE_KEY);

  connect() {
    if (this.hasFormTarget) {
      this.formTarget.addEventListener('submit', this.handleSubmit);
    } // TODO: FC 08feb18 configure Turbolinks cache to remove this?
  }

  disconnect() {
    if (this.hasFormTarget) {
      this.formTarget.removeEventListener('submit', this.handleSubmit);
    } // TODO: FC 08feb18 configure Turbolinks cache to remove this?
  }

  handleSubmit = async event => {
    event.preventDefault();
    event.stopPropagation();

    const { token, error } = await this.stripe.createToken('account', {
      legal_entity: {
        type: 'individual',
        first_name: this.firstNameInputTarget.value,
        last_name: this.lastNameInputTarget.value,
        dob: {
          day: parseInt(document.getElementById('stripe_account_dob_3i').value),
          month: parseInt(
            document.getElementById('stripe_account_dob_2i').value
          ),
          year: parseInt(document.getElementById('stripe_account_dob_1i').value)
        },
        address: {
          line1: this.addressInputTarget.value,
          postal_code: this.postalCodeInputTarget.value,
          city: this.cityInputTarget.value
        }
      },
      tos_shown_and_accepted: true
    });

    if (error) {
      this.accountErrorTarget.textContent = error.message;
    } else {
      this.handleStripeToken(token);
    }
  };

  handleStripeToken = token => {
    this.accountTokenInputTarget.value = token.id;

    this.formTarget.removeEventListener('submit', this.handleSubmit);
    Rails.fire(this.formTarget, 'submit');
  };
}
