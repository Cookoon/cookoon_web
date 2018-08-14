import { Controller } from 'stimulus';
import Swiper from '../vendor/swiper';

export default class extends Controller {
  static targets = ['tooltip'];

  connect() {
    $(this.tooltipTarget).tooltip();
  }

  disconnect() {
    $(this.tooltipTarget).tooltip('dispose');
  }
}
