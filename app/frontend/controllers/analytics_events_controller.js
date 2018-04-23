import { Controller } from 'stimulus';

export default class extends Controller {
  userSearchSubmit() {
    if (typeof gtag === 'function') {
      gtag('event', 'submit', {
        event_category: 'Search'
      });
    }
  }

  reservationModalOpen() {
    if (typeof gtag === 'function') {
      gtag('event', 'open', {
        event_category: 'ReservationModal'
      });
    }
  }

  reservationModalClose() {
    if (typeof gtag === 'function') {
      gtag('event', 'close', {
        event_category: 'ReservationModal'
      });
    }
  }

  reservationPaymentSubmit() {
    if (typeof gtag === 'function') {
      gtag('event', 'submit', {
        event_category: 'ReservationPayment'
      });
    }
  }
}
