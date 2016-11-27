// Events Controller
PW.controllers.places = {
  init: function() 
  {
    // controller-wide code
  },
  showHandleMapsLoad: function() {
    PW.views.locations.header_map.init("map_canvas",rails.location.lat, rails.location.lng);
    $(".search-result").each(function(i,e){
      var target = $(e),
          title = target.find("h4 a").html(),
          lat = target.find(".geo .latitude").html(),
          lng = target.find(".geo .longitude").html();
      if (title != null && lat != null && lng != null) {
        PW.views.locations.header_map.addMarker(title, lat, lng);
      };
    });
    PW.views.locations.header_map.centerOnBounds();
  },
  index: function() 
  {
    PW.maps.google.loadMapApiScript("PW.controllers.search.showHandleMapsLoad");
  }

};