import { Controller } from 'stimulus';
import Swiper from './vendor/swiper';

export default class extends Controller {
  static targets = ['swiperContainer'];

  static parameters = {
    cardCookoon: {
      centeredSlides: true,
      slidesPerView: 'auto',
      spaceBetween: 16
    }
  };

  connect() {
    this.swiper = new Swiper(
      this.swiperContainerTarget,
      this.constructor.parameters[this.data.get('slideComponent')]
    );
  }
}
