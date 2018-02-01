$(document).on('turbolinks:load', function() {
  if ($('.pages.home').length || $('.invitations.edit').length) {
    let mobileBrowser = null;

    if (
      /iP(?:hone|od|ad).*AppleWebKit(?:.*Version)|(?:.*CriOS)/i.test(
        navigator.userAgent
      )
    ) {
      mobileBrowser = 'ios';
    } else if (/Android(?!.*; wv)/i.test(navigator.userAgent)) {
      mobileBrowser = 'android';
    }

    if (mobileBrowser) {
      displayStoreMessage(mobileBrowser);
    }
  }
});

function displayStoreMessage(mobileBrowser) {
  const storeUrl = {
    ios: 'https://itunes.apple.com/fr/app/cookoon-inside/id1291943406?mt=8',
    android:
      'https://play.google.com/store/apps/details?id=cookoon.cookoonandroid'
  };
  if (
    window.confirm(
      "L'application Cookoon est disponible pour votre mobile : souhaitez-vous l'installer ?"
    )
  ) {
    window.location.href = storeUrl[mobileBrowser];
  }
}
