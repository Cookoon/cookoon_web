import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = [
    'form',
    'firstNameInput',
    'lastNameInput',
    'addressInput',
    'postalCodeInput',
    'cityInput',
    'accountError',
    'accountTokenInput',
    'ibanElement',
    'ibanElementError',
    'bankAccountTokenInput',
    'tosAcceptance',
    'tosAcceptanceError'
  ];

  stripe = Stripe(this.data.get('publishableKey'));

  connect() {
    if (this.hasFormTarget) {
      this.formTarget.addEventListener('submit', this.handleSubmit);
    } // TODO: FC 08feb18 configure Turbolinks cache to remove this?

    this.mountIbanElement();
  }

  disconnect() {
    if (this.hasFormTarget) {
      this.formTarget.removeEventListener('submit', this.handleSubmit);
    } // TODO: FC 08feb18 configure Turbolinks cache to remove this?
  }

  mountIbanElement() {
    const style = {
      base: {
        fontSize: '16px',
        color: '#495057'
      }
    };

    const options = {
      style,
      supportedCountries: ['SEPA'],
      placeholderCountry: 'FR'
    };

    this.iban = this.stripe.elements().create('iban', options);

    this.iban.mount(this.ibanElementTarget);

    this.iban.on('change', ({ error }) => {
      const displayError = this.ibanElementErrorTarget;
      if (error) {
        displayError.textContent = error.message;
      } else {
        displayError.textContent = '';
      }
    });
  }

  handleSubmit = async event => {
    event.preventDefault();
    event.stopPropagation();

    if (this.tosAcceptanceTarget.checked) {
      const {
        token: accountToken,
        error: accountError
      } = await this.stripe.createToken('account', {
        business_type: 'individual',
        individual: {
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
        tos_shown_and_accepted: this.tosAcceptanceTarget.checked
      });

      // console.log({ token: accountToken, error: accountError });

      // // Old code for this function
      //     const {
      //       token: accountToken,
      //       error: accountError
      //     } = await this.stripe.createToken('account', {
      //       legal_entity: {
      //         type: 'individual',
      //         first_name: this.firstNameInputTarget.value,
      //         last_name: this.lastNameInputTarget.value,
      //         dob: {
      //           day: parseInt(document.getElementById('stripe_account_dob_3i').value),
      //           month: parseInt(
      //             document.getElementById('stripe_account_dob_2i').value
      //           ),
      //           year: parseInt(document.getElementById('stripe_account_dob_1i').value)
      //         },
      //         address: {
      //           line1: this.addressInputTarget.value,
      //           postal_code: this.postalCodeInputTarget.value,
      //           city: this.cityInputTarget.value
      //         }
      //       },
      //       tos_shown_and_accepted: true
      //     });

      const {
        token: bankAccountToken,
        error: bankAccountError
      } = await this.stripe.createToken(this.iban, {
        currency: 'eur',
        account_holder_name: `${this.firstNameInputTarget.value} ${
          this.lastNameInputTarget.value
        }`,
        account_holder_type: 'individual',
      });

      // console.log({ token: bankAccountToken, error: bankAccountError });

      if (accountError || bankAccountError) {
        // console.log(accountError);
        // console.log(bankAccountError);
        document.getElementById('loader').style = null;

        this.accountErrorTarget.textContent =
          accountError && accountError.message;
        this.ibanElementErrorTarget.textContent =
          bankAccountError && bankAccountError.message;
      } else {
        this.handleStripeTokensSubmit(accountToken, bankAccountToken);
      }

    } else {
      this.tosAcceptanceErrorTarget.textContent = "Vous devez valider les conditions générales d'utilisation, les conditions générales d'utilisation des comptes connectés Stripe et les conditions générales d'utilisation Stripe";
    }
  };

  handleStripeTokensSubmit = (accountToken, bankAccountToken) => {
    this.accountTokenInputTarget.value = accountToken.id;
    this.bankAccountTokenInputTarget.value = bankAccountToken.id;

    this.formTarget.removeEventListener('submit', this.handleSubmit);
    // Rails.fire(this.formTarget, 'submit');
    this.formTarget.submit();
  };
}
