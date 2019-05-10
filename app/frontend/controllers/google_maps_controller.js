// import { Controller } from 'stimulus';
// import GMaps from 'gmaps/gmaps.js';

// export default class extends Controller {
//   static targets = ['cookoonIndexMap', 'cookoonShowMap'];

//   mapOptions = {
//     gestureHandling: 'cooperative',
//     mapTypeControl: false,
//     streetViewControl: false,
//     styles: [
//       {
//         featureType: 'poi.business',
//         stylers: [{ visibility: 'off' }]
//       },
//       {
//         featureType: 'poi.park',
//         elementType: 'labels.text',
//         stylers: [{ visibility: 'off' }]
//       }
//     ]
//   };

//   connect() {
//     if (
//       this.hasCookoonIndexMapTarget &&
//       $(this.cookoonIndexMapTarget).is(':visible')
//     ) {
//       this.renderCookoonIndexMap();
//     }

//     if (this.hasCookoonShowMapTarget) {
//       this.renderCookoonShowMap();
//     }
//   }

//   renderCookoonIndexMap() {
//     const markers = JSON.parse(this.data.get('markers'));
//     const map = new GMaps({
//       div: this.cookoonIndexMapTarget,
//       ...this.mapOptions
//     });
//     map.addMarkers(markers);
//     map.fitLatLngBounds(markers);
//   }

//   renderCookoonShowMap() {
//     const marker = JSON.parse(this.data.get('marker'));

//     const map = new google.maps.Map(this.cookoonShowMapTarget, {
//       zoom: 15,
//       center: marker,
//       ...this.mapOptions
//     });

//     new google.maps.Marker({
//       position: marker,
//       map: map
//     });
//   }
// }
