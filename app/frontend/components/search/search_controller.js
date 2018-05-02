import { Controller } from 'stimulus';
import flatpickr from 'vendor/flatpickr';
import Slider from 'bootstrap-slider';
import 'bootstrap-slider/dist/css/bootstrap-slider';
import './slider';

export default class extends Controller {
  static targets = [
    'body',
    'dateDisplay',
    'dateInput',
    'durationDescription',
    'durationInput',
    'cta',
    'peopleInput',
    'pusher',
    'startAtInput',
    'timeDisplay',
    'timeSelect'
  ];

  connect() {
    const device = this.data.get('device');

    flatpickr(this.dateInputTarget, {
      dateFormat: 'd/m/Y',
      disableMobile: device === 'android_inside',
      minDate: 'today',
      weekNumbers: device === 'desktop'
    });

    this.durationSlider = new Slider(this.durationInputTarget, {
      value: 2,
      ticks: [2, 3, 5, 10],
      ticks_labels: ['2h', '3h', '5h', '10h'],
      ticks_positions: [0, 33.33, 66.66, 100],
      ticks_snap_bounds: 5
    }).on('change', this.renderDurationDescription);
    this.renderDurationDescription();

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
    $(this.pusherTarget).slideToggle();
  }

  pickDate() {
    this.updateStartAtInput();
    this.dateDisplayTarget.textContent = this.dateInputTarget.value;
    // this.timeSelectTarget.click();
  }

  selectTime() {
    this.updateStartAtInput();
    this.timeDisplayTarget.textContent = this.timeSelectTarget.selectedOptions[0].textContent;
  }

  updateStartAtInput() {
    const dateEl = this.dateInputTarget.value.split('/');
    const timeEl = this.timeSelectTarget.value.split(':');
    const date = new Date(
      dateEl[2],
      dateEl[1] - 1,
      dateEl[0],
      timeEl[0],
      timeEl[1]
    );
    if (date instanceof Date && isFinite(date)) {
      this.startAtInputTarget.value = date;
    }
  }

  snapDurationSlider() {
    setTimeout(
      () => this.durationSlider.setValue(this.durationInputTarget.value),
      1
    );
  }

  renderDurationDescription = () => {
    switch (this.durationInputTarget.value) {
      case '2':
        this.durationDescriptionTarget.textContent =
          'Exemple : un rendez-vous ou une réunion rapide';
        break;
      case '3':
        this.durationDescriptionTarget.textContent =
          'Exemple : un déjeuner ou un brainstorming';
        break;
      case '4':
      case '5':
      case '6':
      case '7':
        this.durationDescriptionTarget.textContent =
          'Exemple : un dîner ou une réunion d’équipe';
        break;
      case '8':
      case '9':
      case '10':
        this.durationDescriptionTarget.textContent =
          'Exemple : un shooting ou une journée de séminaire';
        break;
      default:
        this.durationDescriptionTarget.textContent = '';
    }
  };
}
