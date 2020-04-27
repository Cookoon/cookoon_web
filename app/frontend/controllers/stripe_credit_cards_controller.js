import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = ['cardElement', 'cardError', 'form', 'tokenInput', 'cardholderInput'];

  stripe = Stripe(this.data.get('publishableKey'));

  style = {
    base: {
      fontSize: '16px',
      color: '#2C2C2C',
      iconColor: '#2C2C2C',
      '::placeholder': {
        color: '#c9c9c9'
      }
    }
  };

  connect() {
    // Create an instance of the card Element
    const elements = this.stripe.elements();
    this.card = elements.create('card', { style: this.style });

    // Add an instance of the card Element into the cardElementTarget
    this.card.mount(this.cardElementTarget);

    this.card.addEventListener('change', this.handleCardError);

    // Create a token or display an error when the form is submitted.
    this.formTarget.addEventListener('submit', this.handleSubmit);

    // iOS keyboard fix
    $('#credit-card-modal').on('hide.bs.modal', function () {
      $('#invisible-input').focus();
      $('#invisible-input').blur();
    });
  }

  disconnect() {
    this.card.removeEventListener('change', this.handleCardError);
    this.formTarget.removeEventListener('submit', this.handleSubmit);
    this.card = null;
  }

  disableButton() {
    this.formTarget.button.innerHTML = "<i class='fas fa-spinner fa-spin' style='margin-right: 10px;'></i>Chargement";
    this.formTarget.button.disabled = true;
  }

  enableButton() {
    this.formTarget.button.innerHTML = "Payer";
    this.formTarget.button.disabled = false;
  }

  handleCardError = ({ error }) => {
    if (error) {
      this.cardErrorTarget.textContent = error.message;
    } else {
      this.cardErrorTarget.textContent = '';
    }
  };

  handleSubmit = async (event) => {
    event.stopPropagation();
    event.preventDefault();

    this.disableButton();

    const response = await fetch(this.data.get("url"));
    // console.log(response);

    const data = await response.json();
    // console.log(data.client_secret);

    const token = await this.stripe.confirmCardSetup(data.client_secret, {
      payment_method: {
        card: this.card,
        billing_details: {
          name: this.cardholderInputTarget.value,
        },
      },
    });

    // console.log(token);
    // console.log(token.error);
    if (token.error) {
      // Inform the customer that there was an error
      this.cardErrorTarget.textContent = token.error.message;
      this.enableButton();
    } else {
      // Send the token to your server
      this.handleStripeToken(token);
    }
  };

  handleStripeToken = token => {
    // console.log(token);
    // Insert the token ID into the form so it gets submitted to the server
    this.tokenInputTarget.value = token.setupIntent.payment_method;

    // Submit the form
    this.formTarget.removeEventListener('submit', this.handleSubmit);
    Rails.fire(this.formTarget, 'submit');
  };
};