$(document).on('turbolinks:load', function() {
  if ($('.pages.home').length || $('.invitations.edit')) {
    const isIosBrowser = /iP(?:hone|od|ad).*AppleWebKit(?:.*Version)|(?:.*CriOS)/i.test(
      navigator.userAgent
    );
    const isAndroidBrowser = /Android(?!.*; wv)/i.test(navigator.userAgent);

    if (isIosBrowser) {
      if (
        window.confirm(
          "L'application Cookoon est disponible pour votre mobile : souhaitez-vous l'installer ?"
        )
      ) {
        window.location.href =
          'https://itunes.apple.com/fr/app/cookoon-inside/id1291943406?mt=8';
      }
    } else if (isAndroidBrowser) {
      if (
        window.confirm(
          "L'application Cookoon est disponible pour votre mobile : souhaitez-vous l'installer ?"
        )
      ) {
        window.location.href =
          'https://play.google.com/store/apps/details?id=cookoon.cookoonandroid';
      }
    }
  }
});
