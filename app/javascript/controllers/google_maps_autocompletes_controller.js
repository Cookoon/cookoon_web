import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [
    'addressInput',
    'formattedAddress',
    'inputAddress',
    'shortAddress'
  ];

  autocomplete = null;

  connect() {
    this.autocomplete = new google.maps.places.Autocomplete(
      this.addressInputTarget,
      {
        types: ['geocode'],
        componentRestrictions: { country: 'fr' }
      }
    );

    this.autocomplete.addListener('place_changed', this.fillInAddress);

    google.maps.event.addDomListener(
      this.addressInputTarget,
      'keydown',
      event => {
        if (event.keyCode == 13) {
          event.preventDefault();
        }
      }
    );
  }

  disconnect() {
    google.maps.event.clearInstanceListeners(this.autocomplete);
    google.maps.event.clearInstanceListeners(this.addressInputTarget);
    this.autocomplete = null;
  }

  fillInAddress = () => {
    const place = this.autocomplete.getPlace();

    if (this.hasFormattedAddressTarget) {
      return (this.formattedAddressTarget.value = place.formatted_address);
    }

    const addressComponents = this.buildAddressComponents(place);

    if (this.hasInputAddressTarget) {
      this.inputAddressTarget.value = addressComponents.inputAddress;
    }

    if (this.hasShortAddressTarget) {
      this.shortAddressTarget.innerHTML = addressComponents.shortAddress;
    }
  };

  buildAddressComponents(place) {
    let addressComponents = {};

    place.address_components.forEach(addressComponent => {
      addressComponent.types.forEach(type => {
        switch (type) {
          case 'street_number':
            return (addressComponents.streetNumber =
              addressComponent.long_name);
          case 'route':
            return (addressComponents.route = addressComponent.long_name);
          case 'postal_code':
            return (addressComponents.postalCode = addressComponent.long_name);
          case 'locality':
            return (addressComponents.city = addressComponent.long_name);
          case 'country_code':
            return (addressComponents.countryCode =
              addressComponent.short_name);
          case 'country':
            return (addressComponents.country = addressComponent.long_name);
        }
      });
    });

    addressComponents.inputAddress = this.buildInputAddress(addressComponents);
    addressComponents.shortAddress = this.buildShortAddress(addressComponents);

    return addressComponents;
  }

  buildInputAddress({ streetNumber, route, city }) {
    if (streetNumber && route) {
      return streetNumber + ' ' + route + ', ' + city;
    } else if (route) {
      return route + ', ' + city;
    } else {
      return city;
    }
  }

  buildShortAddress({ streetNumber, route, city }) {
    if (streetNumber && route) {
      return streetNumber + ' ' + route;
    } else if (route) {
      return route;
    } else {
      return city;
    }
  }
}
