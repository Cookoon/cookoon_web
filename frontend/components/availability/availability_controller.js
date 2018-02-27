import { Controller } from 'stimulus';

export default class extends Controller {
  static dataAttributes = ['date', 'timeSlot', 'available', 'url', 'method'];

  connect() {
    this.render();
  }

  update() {
    // Example (remove after implementation)
    this.data.set('available', this.data.get('available') !== 'true');
    this.render();

    // // Implementation;
    // const body = {
    //   availability: {
    //     date: this.data.get('date'),
    //     time_slot: this.data.get('timeSlot')
    //   }
    // };
    //
    // fetch(this.data.get('url'), {
    //   method: this.data.get('method'),
    //   body: JSON.stringify(body)
    // })
    //   .then(response => response.json())
    //   .then(data => {
    //     this.data.set('available', data.available);
    //     this.data.set('url', data.url);
    //     this.data.set('method', data.method);
    //     this.render();
    //   });
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
    this.element.innerHTML = `<i class="fa fa-${keyword}" aria-hidden="true"></i>`;
  }

  render() {
    if (this.isMissingDataAttributes()) {
      this.renderFA('square');
    } else if (this.data.get('available') === 'false') {
      this.renderFA('times');
    } else {
      this.renderFA('check');
    }
  }
}
