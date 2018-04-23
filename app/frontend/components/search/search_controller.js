import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    'body',
    'example'
  ]

  toggleBodyVisibility() {
    $(this.bodyTarget).slideToggle();
    $(this.exampleTarget).slideToggle();
  }
}
