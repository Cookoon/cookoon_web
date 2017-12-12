// cookoons#index
$(document).on('turbolinks:load ajaxComplete', function() {
  if (document.getElementById('map-cookoon-index')) {
    var handler = Gmaps.build('Google');
    handler.buildMap(
      {
        provider: {
          scrollwheel: false
        },
        internal: {
          id: 'map-cookoon-index'
        }
      },
      function() {
        markers = handler.addMarkers(markers_json);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
      }
    );
  }
});

// cookoons#show
$(document).on('turbolinks:load ajaxComplete', function() {
  if (document.getElementById('map-cookoon-show')) {
    var handler = Gmaps.build('Google');
    handler.buildMap(
      {
        provider: {
          scrollwheel: false
        },
        internal: {
          id: 'map-cookoon-show'
        }
      },
      function() {
        markers = handler.addMarkers(marker_json);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
        handler.getMap().setZoom(14);
      }
    );
  }
});
