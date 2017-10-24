function onPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);
  $('#user_search_address').trigger('blur').val(components.full_address);
  $('#infos-address').text(components.address == null ? "Adresse" : components.address);
}

function getAddressComponents(place) {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()

  var street_number = null;
  var route = null;
  var zip_code = null;
  var city = null;
  var country_code = null;
  for (var i in place.address_components) {
    var component = place.address_components[i];
    for (var j in component.types) {
      var type = component.types[j];
      if (type == 'street_number') {
        street_number = component.long_name;
      } else if (type == 'route') {
        route = component.long_name;
      } else if (type == 'postal_code') {
        zip_code = component.long_name;
      } else if (type == 'locality') {
        city = component.long_name;
      } else if (type == 'country') {
        country_code = component.short_name;
      }
    }
  }

  return {
    address: buildAddress(street_number, route, city),
    full_address: buildFullAddress(street_number, route, city),
    zip_code: zip_code,
    city: city,
    country_code: country_code
  };
}

function buildAddress(street_number, route, city) {
  if (street_number !== null && route !== null) {
    return street_number + ' ' + route
  }
  else if (route !== null) {
    return route
  }
  else {
    return city
  }
}

function buildFullAddress(street_number, route, city) {
  if (street_number !== null && route !== null) {
    return street_number + ' ' + route + ' ' + city
  }
  else if (route !== null) {
    return route + ' ' + city
  }
  else {
    return city
  }
}
