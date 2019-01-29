import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static serviceChangedEvent = new Event('serviceChanged', { bubbles: true });
  static targets = [ "quantityInput", "icon", "quantityContainer" ]

  toggle() {
    const data = new FormData();
    data.append('service[category]', this.data.get('category'));

    Rails.ajax({
      url: this.data.get('url'),
      type: this.data.get('method'),
      data,
      success: ({ url, method, selected, quantity, html_data }) => {
        this.iconTarget.classList.toggle('service-icon-selected');
        this.data.set('url', url);
        this.data.set('method', method);
        this.data.set('selected', selected);
        if (quantity && this.data.get('category') !== 'special') {
          this.data.set('quantity', quantity);
          this.quantityInputTarget.value = quantity;
          this.quantityContainerTarget.classList.remove('d-none');
        } else {
          this.quantityContainerTarget.classList.add('d-none');
        }
        this.appendMessageIfNeeded(html_data)
        this.element.dispatchEvent(this.constructor.serviceChangedEvent);
      },
      error: ({ errors }, _statusText, _request) => {
        console.log(errors.join(', '));
      }
    });
  }

  updateQuantity() {
    const data = new FormData();
    data.append('service[quantity]', this.quantityInputTarget.value);

    Rails.ajax({
      url: this.data.get('url'),
      type: 'patch',
      data,
      success: ({quantity, html_data}) => {
        this.data.set('quantity', quantity);
        this.appendMessageIfNeeded(html_data)
      },
      error: ({ errors }, _statusText, _request) => {
        console.log(errors.join(', '));
      }
    });
  }

  appendMessageIfNeeded(html_data) {
    const estimationTarget = document.getElementById('price-estimation')
    if (html_data && estimationTarget) {
      estimationTarget.innerHTML = html_data
    }
  }
}
