import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['dateInput'];

  connect() {
    $(this.dateInputTarget)
      .datetimepicker({
        autoclose: true,
        weekStart: 1,
        minuteStep: 30,
        format: 'd MM à h:ii',
        language: 'fr',
        startDate: new Date()
      })
      .on('changeDate', function(event) {
        $(event.currentTarget).click();
      });
  }
}
