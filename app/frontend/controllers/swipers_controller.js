import { Controller } from 'stimulus';
import Swiper from '../vendor/swiper';

export default class extends Controller {
  static targets = ['swiperContainer'];

  connect() {
    this.swiper = new Swiper(this.swiperContainerTarget, {
      loop: true,
      observer: true,
      observeParents: true,

      // transition-duration between 2 slides
      speed: 1000,

      // autoplay duration
      autoplay: {
        delay: 2500,
      },

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
