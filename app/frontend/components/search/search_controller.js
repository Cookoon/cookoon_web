import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    'body',
    'example'
  ]

  connect() {
    console.log("Hello, Stimulus!", this.element);
  }

  toggleBodyVisibility() {
    $(this.bodyTarget).slideToggle();
    $(this.exampleTarget).slideToggle();
  }
}
