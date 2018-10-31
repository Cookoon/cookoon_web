import { Controller } from 'stimulus'
import PhotoSwipe from 'photoswipe'
import PhotoSwipeUI_Default from 'photoswipe/dist/photoswipe-ui-default'
import 'photoswipe/dist/photoswipe.css'
import 'photoswipe/dist/default-skin/default-skin.css'

export default class extends Controller {
  static targets = ['pswpElement']

  connect() {
    this.options = {
      index: 0,
      history: false,
      shareEl: false
    }
  }

  open(event) {
    this.pswp.init()
  }

  get items() {
    return JSON.parse(this.data.get('items'))
  }

  get pswp() {
    return new PhotoSwipe(
      this.pswpElementTarget,
      PhotoSwipeUI_Default,
      this.items,
      this.options
    )
  }
}
