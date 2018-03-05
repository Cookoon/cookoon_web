import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['addressInput', 'formattedAddress', 'shortAddress'];

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
      this.formattedAddressTarget.value = place.formatted_address;
    }

    if (this.hasAddressInputTarget) {
      this.addressInputTarget.value = place.formatted_address;
    }

    if (this.hasShortAddressTarget) {
      this.shortAddressTarget.textContent = place.name;
    }
  };
}
