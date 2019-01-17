import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['estimation']

  connect() {
    document.addEventListener('serviceChanged', this.fetchPriceEstimation)
  }

  disconnect() {
    document.removeEventListener('serviceChanged', this.fetchPriceEstimation)
  }

  fetchPriceEstimation = () => {
    $.ajax({
      type: 'GET',
      dataType: 'script',
      url: this.data.get('url')
    });
  }
}
