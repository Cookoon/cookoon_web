import { Controller } from "stimulus";
import Rails from 'rails-ujs';

export default class extends Controller {
  static priceChangedEvent = new Event('serviceChanged', {'bubbles': true});

  toggle() {
    const data = new FormData();
    data.append('service[category]', this.data.get('category'));

    Rails.ajax({
      url: this.data.get('url'),
      type: this.data.get('method'),
      data,
      success: ({url, method, selected}) => {
        this.element.classList.toggle("service-selected");
        this.data.set('url', url);
        this.data.set('method', method);
        this.data.set('selected', selected);
        this.element.dispatchEvent(this.constructor.priceChangedEvent);
      },
      error: (_jqXHR, _textStatus, errorThrown) => {
        console.log(errorThrown);
      }
    });
  }
}
