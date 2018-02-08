// $(document).on('turbolinks:load ajaxComplete', function() {
//   autocomplete(document.getElementById('user_search_address'));
//   autocomplete(document.getElementById('cookoon_address'));
// });
//
// function autocomplete(addressInput) {
//   if (addressInput) {
//     var autocomplete = new google.maps.places.Autocomplete(addressInput, {
//       types: ['geocode'],
//       componentRestrictions: { country: 'fr' }
//     });
//     google.maps.event.addListener(
//       autocomplete,
//       'place_changed',
//       onPlaceChanged
//     );
//     google.maps.event.addDomListener(addressInput, 'keydown', function(e) {
//       if (e.keyCode == 13) {
//         e.preventDefault();
//       }
//     });
//   }
// }
//
// function onPlaceChanged() {
//   var place = this.getPlace();
//   var components = getAddressComponents(place);
//   if ($('.cookoons.index').length) {
//     $('#user_search_address')
//       .trigger('blur')
//       .val(components.full_address);
//     $('#infos-address').text(
//       components.address == null ? 'Adresse' : components.address
//     );
//   } // TODO [FC 11dec17] refactor this in a more elegant fashion
// }
//
// function getAddressComponents(place) {
//   // If you want lat/lng, you can look at:
//   // - place.geometry.location.lat()
//   // - place.geometry.location.lng()
//
//   var street_number = null;
//   var route = null;
//   var zip_code = null;
//   var city = null;
//   var country_code = null;
//   for (var i in place.address_components) {
//     var component = place.address_components[i];
//     for (var j in component.types) {
//       var type = component.types[j];
//       if (type == 'street_number') {
//         street_number = component.long_name;
//       } else if (type == 'route') {
//         route = component.long_name;
//       } else if (type == 'postal_code') {
//         zip_code = component.long_name;
//       } else if (type == 'locality') {
//         city = component.long_name;
//       } else if (type == 'country') {
//         country_code = component.short_name;
//       }
//     }
//   }
//
//   return {
//     address: buildAddress(street_number, route, city),
//     full_address: buildFullAddress(street_number, route, city),
//     zip_code: zip_code,
//     city: city,
//     country_code: country_code
//   };
// }
//
// function buildAddress(street_number, route, city) {
//   if (street_number !== null && route !== null) {
//     return street_number + ' ' + route;
//   } else if (route !== null) {
//     return route;
//   } else {
//     return city;
//   }
// }
//
// function buildFullAddress(street_number, route, city) {
//   if (street_number !== null && route !== null) {
//     return street_number + ' ' + route + ', ' + city;
//   } else if (route !== null) {
//     return route + ', ' + city;
//   } else {
//     return city;
//   }
// }
