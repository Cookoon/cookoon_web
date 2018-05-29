import { Controller } from 'stimulus';
import 'vendor/slideAndSwipe';

export default class extends Controller {
  connect() {
    $('.drawer').slideAndSwipe();
  }
}
