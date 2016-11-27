PW.views.locations = {}
PW.views.locations.header_map = {
  map: null,
  markers: [],
  bounds: null,
  init: function(divId, lat, lng) {
    var lat = lat;
    var lng = lng;
    var mapOptions = {
      center: new google.maps.LatLng(lat, lng),
      zoom: 20,
      mapTypeId: google.maps.MapTypeId.HYBRID,
      mapTypeControl: true,
      mapTypeControlOptions: {
          style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
          position: google.maps.ControlPosition.BOTTOM_CENTER
      },
      panControl: true,
      panControlOptions: {
          position: google.maps.ControlPosition.LEFT_CENTER
      },
      zoomControl: true,
      zoomControlOptions: {
          style: google.maps.ZoomControlStyle.SMALL,
          position: google.maps.ControlPosition.LEFT_CENTER
      },
      scaleControl: false,
      streetViewControl: true,
      streetViewControlOptions: {
          position: google.maps.ControlPosition.LEFT_CENTER
      },
      styles: [
        {
          "stylers": [
            { "saturation": -65 },
            { "hue": "#ffee00" }
          ]
        }
      ]
    };
    this.bounds = new google.maps.LatLngBounds();
    this.map    = new google.maps.Map(document.getElementById(divId), mapOptions);
    $(window).resize(function(){
      if (this.map != undefined) {
        this.map.setCenter(lat,lng);
      };
    });
  },
  addMarker: function(title, lat, lng) {
    var location = new google.maps.LatLng(lat, lng);
    this.bounds.extend(location);
    var marker = new google.maps.Marker({
              map:this.map,
              draggable:false,
              animation: google.maps.Animation.DROP,
              position: location,
              title: title
            });
    this.markers.push(marker);
  },
  centerOnBounds: function(){
    this.map.fitBounds(this.bounds);
  }
}