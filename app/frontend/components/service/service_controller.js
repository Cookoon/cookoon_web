import { Controller } from "stimulus";
import Rails from 'rails-ujs';

export default class extends Controller {
  connect() {

  }

  toggle() {
    const data = new FormData();
    data.append('service[category]', this.data.get('category'));

    Rails.ajax({
      url: this.data.get('url'),
      type: this.data.get('method'),
      data,
      success: () => {
        this.element.classList.toggle("service-icon-selected");
        this.data.set('selected', 'true');
        // this.data.set('selected', selected);
      },
      error: () => { console.log('error') }
    });

    const priceChangedEvent = new Event('serviceChanged');
    document.dispatchEvent(priceChangedEvent);
  }
}
