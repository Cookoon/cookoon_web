import { Controller } from 'stimulus';
import Rails from 'rails-ujs';

export default class extends Controller {
  static dataAttributes = ['date', 'timeSlot', 'available', 'url', 'method'];

  connect() {
    this.render();
  }

  update() {
    const data = new FormData();
    data.append('availability[date]', this.data.get('date'));
    data.append('availability[time_slot]', this.data.get('timeSlot'));

    Rails.ajax({
      url: this.data.get('url'),
      type: this.data.get('method'),
      data,
      success: ({ available, url, method }) => {
        if (
          available !== undefined &&
          url !== undefined &&
          method !== undefined
        ) {
          this.data.set('available', available);
          this.data.set('url', url);
          this.data.set('method', method);
          this.render();
        }
      },
      error: (_jqXHR, _textStatus, errorThrown) => {
        console.log(errorThrown);
      }
    });
  }

  isMissingDataAttributes() {
    return !this.constructor.dataAttributes.reduce(
      (presence, dataAttribute) =>
        presence && this.isDataAttributePresent(dataAttribute)
    );
  }

  isDataAttributePresent(dataAttribute) {
    return this.data.has(dataAttribute) && this.data.get(dataAttribute) !== '';
  }

  renderFA(keyword) {
    this.element.innerHTML = `<i class="fa fa-${keyword} fa-lg pointer" aria-hidden="true"></i>`;
  }

  render() {
    if (this.isMissingDataAttributes()) {
      this.renderFA('square');
    } else if (this.data.get('available') === 'false') {
      this.renderFA('times text-dark');
    } else {
      this.renderFA('check');
    }
  }
}
