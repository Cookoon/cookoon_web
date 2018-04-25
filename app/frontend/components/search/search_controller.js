import { Controller } from 'stimulus';
import Slider from 'bootstrap-slider';
import 'bootstrap-slider/dist/css/bootstrap-slider';
import './slider';

export default class extends Controller {
  static targets = ['body', 'durationInput', 'cta', 'peopleInput'];

  connect() {
    this.durationSlider = new Slider(this.durationInputTarget, {
      value: 2,
      ticks: [2, 3, 5, 10],
      ticks_labels: ['2h', '3h', '5h', '10h'],
      ticks_positions: [0, 33.33, 66.66, 100],
      ticks_snap_bounds: 5
    });
    this.peopleSlider = new Slider(this.peopleInputTarget, {
      value: 4,
      ticks: [2, 4, 6, 8, 10, 12],
      ticks_labels: ['2', '4', '6', '8', '10', '12']
    });
  }

  toggleBodyVisibility() {
    $(this.bodyTarget).slideToggle();
    this.durationSlider.relayout();
    this.peopleSlider.relayout();
    $(this.ctaTarget).slideToggle();
  }

  snapDurationSlider() {
    setTimeout(
      () => this.durationSlider.setValue(this.durationInputTarget.value),
      1
    );
  }
}
