import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = ['paymentForm', 'paymentSelection', 'paymentError'];
  // static targets = ['paymentForm', 'paymentSelection', 'paymentError', 'paymentSuccess'];

  stripe = Stripe(this.data.get('publishableKey'));

  connect() {
    // Confirm the payment intent or display an error when the form is submitted.
    this.paymentFormTarget.addEventListener('submit', this.handleSubmit);
    // console.log(this.paymentFormTarget);
    // console.log(this.paymentSelectionTarget);
    // console.log(this.paymentErrorTarget);
    // console.log(this.paymentSuccessTarget);

    // iOS keyboard fix
    $('#credit-card-modal').on('hide.bs.modal', function () {
      $('#invisible-input').focus();
      $('#invisible-input').blur();
    });
  }

  disconnect() {
    this.paymentFormTarget.removeEventListener('submit', this.handleSubmit);
  }

  disableButton() {
    this.paymentFormTarget.button.innerHTML = "<i class='fas fa-spinner fa-spin' style='margin-right: 10px;'></i>Chargement";
    this.paymentFormTarget.button.disabled = true;
  }

  enableButton() {
    this.paymentFormTarget.button.innerHTML = "Payer";
    this.paymentFormTarget.button.disabled = false;
  }

  handleSubmit = async (event) => {
    event.stopPropagation();
    event.preventDefault();

    this.disableButton();

    const response = await fetch(this.data.get("url"));
    // console.log(response);

    const data = await response.json();
    // console.log(data.clientSecret);

    // this.paymentSelected = this.paymentSelectionTarget.selectedOptions[0].innerHTML;
    this.paymentSelected = this.paymentSelectionTarget.selectedOptions[0].value;
    // console.log(this.paymentSelected);

    const result = await this.stripe.confirmCardPayment(data.clientSecret, {
      payment_method: this.paymentSelected
      }
    );
    // console.log(result);

    if (result.error) {
      // Inform the customer that there was an error
      this.paymentErrorTarget.classList.add("my-4");
      this.paymentErrorTarget.textContent = result.error.message;
      this.enableButton();
    } else {
      this.paymentFormTarget.removeEventListener('submit', this.handleSubmit);
      // Hide paymentForm
      this.paymentFormTarget.style.display = "none";
      // // Add a success payment message
      // this.paymentSuccessTarget.classList.add("mb-4");
      // this.paymentSuccessTarget.textContent = "Votre paiement a bien été enregistré";
      // Submit the form
      Rails.fire(this.paymentFormTarget, 'submit');
      // this.paymentFormTarget.submit();
    }
  };
};
