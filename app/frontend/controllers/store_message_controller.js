import { Controller } from 'stimulus';

export default class extends Controller {
  branchLink = 'https://cookoon.app.link?$deeplink_path=';

  connect() {
    if (['ios_browser', 'android_browser'].includes(this.data.get('device'))) {
      this.popStoreMessage();
    }
  }

  popStoreMessage() {
    console.log(
      'https://cookoon.app.link?$deeplink_path='.concat(window.location.href)
    );
    if (
      window.confirm(
        "L'application Cookoon est disponible pour votre mobile : souhaitez-vous l'installer ?"
      )
    ) {
      window.location.href = this.branchLink.concat(
        encodeURIComponent(window.location.href)
      );
    }
  }
}
