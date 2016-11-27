PW.controllers.browse = {
  init: function() 
  {
    this.location();
  },
  
  location: function()
  {
  
    var markers=[];
    var map;
    $(".topbar").after("<div id='fat_map'><div id='map'></div></div>");
    showMap = function() 
    {
      var boundingBox = rails.place.geoplanet_place.bounding_box;
      var sw     = new google.maps.LatLng(boundingBox[0][0], boundingBox[0][1]);
      var ne     = new google.maps.LatLng(boundingBox[1][0], boundingBox[1][1]);
      var bounds = new google.maps.LatLngBounds(sw, ne);
      
      var carmelvalley = new google.maps.LatLng(42.7549015, -95.5556282); 
      // var carmelvalley = bounds.getCenter();
      var map, marker;
      var markersArray = [];
      var myOptions = {
        zoom: 15,
        noClear: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      map = new google.maps.Map(document.getElementById("map"), myOptions);
      map.setCenter(bounds.getCenter());
      map.fitBounds(bounds);
      
      var rectangle = new google.maps.Rectangle();
      var rectOptions = {
        strokeColor: "#FF0000",
        strokeOpacity: 0.2,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.05,
        map: map,
        bounds: bounds
      };
      rectangle.setOptions(rectOptions);
      
      var markerBounds = new google.maps.LatLngBounds();
      var markerCount = 0;
      $("a.zoomBtn").each(function(x, item){
        markerCount++
        var lat        = $(item).attr("data-lat");
        var lng        = $(item).attr("data-lng");
        var locationId = $(item).attr("data-locationId");
        var title      = $(item).siblings(".parkInfo").find("a").text();
        var latLng     = new google.maps.LatLng(lat, lng);
        //
        var infowindow = new google.maps.InfoWindow({
          content: _.template($("#markerQATemplate").text())({locationId:locationId})
        });

        var marker = new google.maps.Marker({ 
          map       : map,
          draggable : false,
          title     : title,
          position  : latLng,
          openInfoWindow : function() {
              infowindow.open(map,marker);
          }
        });
        markerBounds.extend(latLng)
        bounds.extend(latLng)
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map,marker);
        });

        
        $(item).attr("data-marker-id",markers.length);
        markers.push(marker);
      });
      if(markerCount == 0)
        map.fitBounds(bounds);
      else
        map.fitBounds(markerBounds);
      
      $("a.zoomBtn").click(function(e){
        var link = $(e.currentTarget);
        var marker = markers[link.attr("data-marker-id")];

        map.setCenter(marker.getPosition());
        map.setZoom(19);
        map.setMapTypeId('hybrid');
        /* */
        $(".selected").removeClass("selected");
        $(".disabled").removeClass("disabled");
        
        link.parent().addClass("selected");
        link.addClass("disabled");
        
        /*
        $("#parkTest").remove();
        var form = $("#parkTestTemplate").text();
        link.parent(".parkListing").after(_.template(form))
        $("#parkTest").delay(250).fadeIn();
        */
        marker.openInfoWindow();
        
        e.stopPropagation();
        e.preventDefault();
      });
      /*
      * Watch verify marker form
      */
      $('form').live('ajax:complete', function(event, xhr, status) {
        // debugger;
        var msg = $.parseJSON(xhr['responseText']);
        $(this).parents("div.markerQA").replaceWith("<div>"+msg['message']+"</div>");
      });
      
    }
    function loadScript() {
      var script  = document.createElement("script");
      script.type = "text/javascript";
      script.src  = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=showMap";
      document.body.appendChild(script);
    }
    window.onload = loadScript;
  },
  
  country: function()
  {
    this.location();
  }
  
  
  
}