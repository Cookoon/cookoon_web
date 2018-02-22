import { Controller } from 'stimulus';
import Swiper from '../components/swiper/index';

export default class extends Controller {
  static targets = ['swiperContainer'];

  swiper = null;

  connect() {
    this.swiper = new Swiper(this.swiperContainerTarget, {
      loop: true,

      pagination: {
        el: '.swiper-pagination'
      },

      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev'
      }
    });
  }

  disconnect() {
    this.swiper = null;
  }
}
