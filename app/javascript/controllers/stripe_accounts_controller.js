import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = ['accountError', 'form', 'tokenInput'];

  stripe = Stripe(process.env.STRIPE_PUBLISHABLE_KEY);

  connect() {
    console.log(process.env.STRIPE_PUBLISHABLE_KEY);
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
        first_name: document.querySelector('.inp-first-name').value,
        last_name: document.querySelector('.inp-last-name').value,
        type: 'individual',
        address: {
          line1: document.querySelector('.inp-street-address1').value,
          city: document.querySelector('.inp-city').value,
          postal_code: document.querySelector('.inp-zip').value
        },
        dob: {
          day: parseInt(document.querySelector('#stripe_dob_3i').value),
          month: parseInt(document.querySelector('#stripe_dob_2i').value),
          year: parseInt(document.querySelector('#stripe_dob_1i').value)
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
    this.tokenInputTarget.value = token.id;

    this.formTarget.removeEventListener('submit', this.handleSubmit);
    Rails.fire(this.formTarget, 'submit');
  };
}
