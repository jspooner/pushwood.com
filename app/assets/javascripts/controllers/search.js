// Events Controller
PW.controllers.search = {
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
    function facet_locations() {
      var selected        = $("input[name=facet_locations]:checked");
      var facet_locations = _.map(selected, function(i){ return $(i).val(); });
      return facet_locations;
    }
    function facet_features() {
      var selected        = $("input[name=facet_features]:checked");
      return _.map(selected, function(i){ return $(i).val(); });
    }
    // Search
    function updateResults() {
      
      var uri             = location.search.replace("?", "").split("&");
      var params          = {}
      for (var i=0; i < uri.length; i++) {
        var kv        = uri[i].split("=");
        params[kv[0]] = kv[1];
      };
      params['facet_locations'] = facet_locations().join(",");
      params['facet_features']  = facet_features().join(",");
      params['query']           = $("#query").val();
      var query = _.map(params, function(v,k) { return k + "=" + v; });
      location.href = '/search?' + query.join("&");
    }
    // Facet List
    // if onlyChild is truned on it should turn all others off.
    // if onlyChild is turned off automaticly turn it's back on
    
    // if siblingChild is truned on locationOnlyChildren should turn off
    // if no siblingChildren are selected then the fist onlyChild should automaticly be selected
    var locationOnlyChildren = $("#locationList input.onlyChild");
    $("#locationList input.onlyChild").click(function(e){
      // Disable the other child
      locationOnlyChildren.each(function(i,child) {
        if (child != e.currentTarget) 
          $(child).attr('checked',false);
      });
      // Disable the siblings
      $("#locationList input.siblings").each(function(i,child){
        $(child).attr('checked',false);
      });
      
      updateResults();
    });
    
    $("#locationList input.siblings").click(function(e){
      locationOnlyChildren.each(function(i,child) {
        $(child).attr('checked',false);
      });
      // Default to Current Location
      if ( $("#locationList input.siblings:checked").length == 0 )
        $(locationOnlyChildren[1]).attr('checked',true);
      
      updateResults();
    });
    
    // Features Facet List
    var featureOnlyChildren = $("#featureList input.onlyChild");
    $("#featureList input.onlyChild").click(function(e){
      // Disable the other child
      featureOnlyChildren.each(function(i,child) {
        if (child != e.currentTarget) 
          $(child).attr('checked',false);
      });
      // Disable the siblings
      $("#featureList input.siblings").each(function(i,child){
        $(child).attr('checked',false);
      });
      
      updateResults();
    });
    
    $("#featureList input.siblings").click(function(e){
      featureOnlyChildren.each(function(i,child) {
        $(child).attr('checked',false);
      });
      // Default to Current Location
      if ( $("#featureList input.siblings:checked").length == 0 )
        $(featureOnlyChildren[1]).attr('checked',true);
      
      updateResults();
    });
    
    
    $("#advancedSearch").submit(function(e){
      updateResults();
      return false;
    });
  }

};