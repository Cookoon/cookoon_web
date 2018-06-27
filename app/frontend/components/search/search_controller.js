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
    'peopleSliderDecreaser',
    'peopleSliderIncreaser',
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
      ticks: [2, 3, 5, 7, 10],
      ticks_labels: ['2h', '3h', '5h', '7h', '10h'],
      ticks_positions: [0, 25, 50, 75, 100],
      ticks_snap_bounds: 5
    }).on('change', this.renderDurationDescription);
    this.renderDurationDescription();

    this.peopleSlider = new Slider(this.peopleInputTarget, {
      value: 4,
      ticks: [2, 4, 6, 8, 10, 12],
      ticks_labels: ['2', '4', '6', '8', '10', '12']
    });
  }

  disconnect() {
    this.durationSlider.destroy();
    this.peopleSlider.destroy();
  }

  toggleBodyVisibility() {
    $(this.bodyTarget).slideToggle(600);
    this.durationSlider.relayout();
    this.peopleSlider.relayout();

    $(this.pusherTarget).slideToggle(600);

    setTimeout(() => $(this.ctaTarget).slideToggle(200), 200);
  }

  pickDate() {
    this.updateStartAtInput();
    this.renderDateDisplay();
  }

  selectTime() {
    this.updateStartAtInput();
    this.renderTimeDisplay();
  }

  renderDateDisplay() {
    if (/\d{2}\/\d{2}\/\d{4}/.test(this.dateInputTarget.value)) {
      this.dateDisplayTarget.textContent = this.dateInputTarget.value;
    } else {
      this.dateDisplayTarget.textContent = 'JJ/MM/AAAA';
    }
  }

  renderTimeDisplay() {
    if (/\d{1,2}:\d{2}/.test(this.timeSelectTarget.selectedOptions[0].value)) {
      this.timeDisplayTarget.textContent = this.timeSelectTarget.selectedOptions[0].textContent;
    } else {
      this.timeDisplayTarget.textContent = '00h';
    }
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
    } else {
      this.startAtInputTarget.value = '';
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
          'Pour un rendez-vous ? une réunion rapide ?';
        break;
      case '3':
        this.durationDescriptionTarget.textContent =
          'Pour un déjeuner ? un brainstorming ?';
        break;
      case '4':
      case '5':
        this.durationDescriptionTarget.textContent =
          "Pour un dîner ? une réunion d'équipe ?";
        break;
      case '6':
      case '7':
        this.durationDescriptionTarget.textContent =
          "Un grand dîner ? Un comité d'entreprise ?";
        break;
      case '8':
      case '9':
      case '10':
        this.durationDescriptionTarget.textContent =
          'Pour une journée de séminaire ? un vide-dressing ?';
        break;
      default:
        this.durationDescriptionTarget.textContent = '';
    }
  };

  decreasePeopleSlider() {
    this.peopleSliderDecreaserTarget.style.display = 'none';
    this.peopleSliderIncreaserTarget.style.display = 'initial';

    this.peopleSlider.destroy();
    this.peopleSlider = new Slider(this.peopleInputTarget, {
      value: 12,
      ticks: [2, 4, 6, 8, 10, 12],
      ticks_labels: ['2', '4', '6', '8', '10', '12']
    });
  }

  increasePeopleSlider() {
    this.peopleSliderIncreaserTarget.style.display = 'none';
    this.peopleSliderDecreaserTarget.style.display = 'initial';

    this.peopleSlider.destroy();
    this.peopleSlider = new Slider(this.peopleInputTarget, {
      value: 12,
      ticks: [12, 14, 16, 18, 20],
      ticks_labels: ['12', '14', '16', '18', '20']
    });
  }
}
