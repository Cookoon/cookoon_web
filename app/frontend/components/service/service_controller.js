import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static serviceChangedEvent = new Event('serviceChanged', { bubbles: true });
  static targets = [ "quantityInput", "icon" ]


  toggle() {
    const data = new FormData();
    data.append('service[category]', this.data.get('category'));

    Rails.ajax({
      url: this.data.get('url'),
      type: this.data.get('method'),
      data,
      success: ({ url, method, selected, quantity }) => {
        this.iconTarget.classList.toggle('service-icon-selected');
        this.data.set('url', url);
        this.data.set('method', method);
        this.data.set('selected', selected);
        if (quantity) {
          this.data.set('quantity', quantity);
          this.quantityInputTarget.value = quantity;
          this.quantityInputTarget.classList.remove('d-none');
        } else {
          this.quantityInputTarget.classList.add('d-none');
        }
        this.element.dispatchEvent(this.constructor.serviceChangedEvent);
      },
      error: ({ errors }, _statusText, _request) => {
        console.log(errors.join(', '));
      }
    });
  }

  updateQuantity() {
    const data = new FormData();
    data.append('service[quantity]', this.element.querySelector('input').value);

    Rails.ajax({
      url: this.data.get('url'),
      type: 'patch',
      data,
      success: ({quantity}) => {
        this.data.set('quantity', quantity);
      },
      error: ({ errors }, _statusText, _request) => {
        console.log(errors.join(', '));
      }
    });
  }
}
