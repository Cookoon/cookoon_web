function getGeoLocation() {
  navigator.geolocation.getCurrentPosition(setCookie);
}

function setCookie(position) {
  $.ajax({
    type:'GET',
    url:'/setcookies',
    data: { lat: position.coords.latitude, lng: position.coords.longitude }
  });
}
