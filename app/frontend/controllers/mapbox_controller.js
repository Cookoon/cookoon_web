import { Controller } from 'stimulus';
import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

export default class extends Controller {
  static targets = [
    'map',
  ];

  connect() {
    this.initMapbox()
  }

  initMapbox() {
    const mapElement = this.mapTarget;
    const marker = JSON.parse(mapElement.dataset.marker);

    if (mapElement) {
      const map = this.buildMap()
      this.addMarkerToMap(map, marker);
      this.fitMapToMarker(map, marker);
      map.on('load', function () {
        map.resize();
      });
    }
  }

  addMarkerToMap(map, marker) {
    return new mapboxgl.Marker().setLngLat([marker.lng, marker.lat]).addTo(map)
  }

  buildMap() {
    mapboxgl.accessToken = this.mapTarget.dataset.mapboxApiKey
    return new mapboxgl.Map({
      container: 'map_container',
      style: 'mapbox://styles/mapbox/streets-v11',
    });
  }

  fitMapToMarker(map, marker) {
    const bound = new mapboxgl.LngLatBounds();
    bound.extend([ marker.lng, marker.lat ]);
    map.fitBounds(bound, { padding: 70, maxZoom: 10 });
  }
}
