import { Controller } from "stimulus";
import Rails from 'rails-ujs';

export default class extends Controller {
  static dataAttributes = ['category', 'selected'];

  connect() {

  }

  toggle() {
    Rails.ajax({
      url: this.data.get('url'),
      type: this.data.get('method'),
      data: { category: this.data.get('category') },
      success: { console.log('success') },
      error: { console.log('error') }
    });

    const priceChangedEvent = new Event('serviceChanged');
    this.element.classList.toggle("service-icon-selected");
    document.dispatchEvent(priceChangedEvent);
  }
}
