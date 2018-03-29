import { Controller } from 'stimulus';

export default class extends Controller {
  userSearchSubmit() {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'submit', {
        event_category: 'UserSearch'
      });
    }
  }

  reservationModalOpen() {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'open', {
        event_category: 'ReservationModal'
      });
    }
  }

  reservationModalClose() {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'close', {
        event_category: 'ReservationModal'
      });
    }
  }

  reservationPaymentSubmit() {
    if (typeof gtag !== 'undefined') {
      gtag('event', 'submit', {
        event_category: 'ReservationPayment'
      });
    }
  }
}
