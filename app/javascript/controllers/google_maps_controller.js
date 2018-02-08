import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['cookoonIndexMap', 'cookoonShowMap'];

  mapOptions = {
    gestureHandling: 'cooperative',
    mapTypeControl: false,
    streetViewControl: false,
    styles: [
      {
        featureType: 'poi.business',
        stylers: [{ visibility: 'off' }]
      },
      {
        featureType: 'poi.park',
        elementType: 'labels.text',
        stylers: [{ visibility: 'off' }]
      }
    ]
  };

  connect() {
    if (this.hasCookoonIndexMapTarget) {
      this.renderCookoonIndexMap();
    }

    if (this.hasCookoonShowMapTarget) {
      this.renderCookoonShowMap();
    }
  }

  renderCookoonIndexMap() {
    const handler = Gmaps.build('Google');
    handler.buildMap(
      {
        provider: this.mapOptions,
        internal: {
          id: 'cookoon-index-map'
        }
      },
      function() {
        const markers = handler.addMarkers(markers_json);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
      }
    );
  }

  renderCookoonShowMap() {
    const map = new google.maps.Map(this.cookoonShowMapTarget, {
      zoom: 15,
      center: markerObject,
      ...this.mapOptions
    });
    new google.maps.Marker({
      position: markerObject,
      map: map
    });
  }
}
