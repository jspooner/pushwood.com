// Events Controller
PW.controllers.locations = {
  
  init: function() {
    // controller-wide code
  },
  
  index: function() {
  },
  
  show: function() {
    $('#myTabs a').click(function (e) {
      e.preventDefault();
      $(this).tab('show');
    });
    
    // Load the google maps api
    console.log("Load the google maps api")
    PW.maps.google.loadMapApiScript("PW.controllers.locations.showHandleMapsLoad");
    // PW.views.locations.photo_gallery.init();
    
    add_fields = function(link, association, content) {
      var new_id = new Date().getTime();
      var regexp = new RegExp("new_" + association, "g")
      $("#newImgList li:last").after(content.replace(regexp, new_id));
    }
  },
  
  showHandleMapsLoad: function() {
    if (rails.location.lat == undefined) {
      PW.views.locations.header_map.init("map_canvas", rails.location.location.lat, rails.location.location.lng);
    } else {
      PW.views.locations.header_map.init("map_canvas", rails.location.lat, rails.location.lng);
    };
  },
  
  create: function() {
    PW.controllers.locations.edit();
  },
  
  edit: function() {
    PW.controllers.locations.init_form();
  },
  
  'new': function() {
    // action-specific code
    PW.controllers.locations.init_form();
  },
  init_form: function() {
    // set up image fields
    remove_fields = function(link) {
      $(link).prev("input[type=hidden]").val("1");
      $(link).closest(".field").hide();
    }
    add_fields = function(link, association, content) {
      var new_id = new Date().getTime();
      var regexp = new RegExp("new_" + association, "g")
      $(link).parent().after(content.replace(regexp, new_id));
    }
    // set up map
    var map, marker;
    var myOptions = {
      zoom: 19,
      mapTypeId: google.maps.MapTypeId.HYBRID
    };
    var lat            = $("#location_lat").val();
    var lng            = $("#location_lng").val();
    var centerLocation = new google.maps.LatLng( lat, lng ); 
    map                = new google.maps.Map(document.getElementById("exactLocationMap"), myOptions);
    map.setCenter(centerLocation);
    marker             = new google.maps.Marker({ map: map, draggable: true, position: centerLocation });
    /**
    * Fill in users current location
    */
    $("#useCurrentLocation").click(function(e) {
      e.stopPropagation();
      e.preventDefault();
      PW.maps.google.userLocation(function(latLng){
        $("#location_lat").val(latLng.lat());
        $("#location_lng").val(latLng.lng());
        PW.maps.reverseGeocode($("#location_lat").val(), $("#location_lng").val(), function(results) {
          if (results != undefined && results[0] != undefined) {
            var address = PW.maps.google.toUSAAddress(results[0]);
            $("#location_street").val(address['street']);
            $("#location_city").val(address['city']);
            $("#location_state").val(address['state']);
            $("#location_postal").val(address['postal']);
            $("#location_country").val(address['country']);
            var latLng = new google.maps.LatLng( $("#location_lat").val(), $("#location_lng").val() );
            marker.setPosition(latLng);
            map.setCenter(latLng);
          };
        });
      });
      
    });
    $("#updateAddress").click(function(e){
      e.stopPropagation();
      e.preventDefault();
      PW.maps.reverseGeocode($("#location_lat").val(), $("#location_lng").val(), function(results) {
        if (results != undefined && results[0] != undefined) {
          var address = PW.maps.google.toUSAAddress(results[0]);
          console.log(address)
          $("#location_street").val(address['street']);
          $("#location_city").val(address['city']);
          $("#location_state").val(address['state']);
          $("#location_postal").val(address['postal']);
          $("#location_country").val(address['country']);
        } else {
          alert("We could not find an address for that location")
          console.log(results)
        }
      });
    });
    $("#updateMarker").click(function(e){
      e.stopPropagation();
      e.preventDefault();
      var street    = $("#location_street").val(),
            city    = $("#location_city").val(),
            state   = $("#location_state").val(),
            postal  = $("#location_postal").val(),
            country = $("#location_country").val();
      if (street != "" && city != "" && state != "") {
        var address = street + ' ' + city + ' ' + state + ' ' + postal + ' ' + country;
        PW.maps.geocode({'address':address}, function(results) {
          if (results != undefined && results[0] != undefined) {
            var lat    = results[0].geometry.location.lat(),
                lng    = results[0].geometry.location.lng(),
                latLng = new google.maps.LatLng(lat,lng);
            $("#location_lat").val(lat);
            $("#location_lng").val(lng);
            marker.setPosition(latLng);
            map.setCenter(latLng);
          };
        });
      } else {
        alert("Please add an address.");
      }
    });
    /**
    * watch the address fields and update marker
    */
    // $("#location_street, #location_city, #location_state, #location_postal, #location_country").blur(function(event){
    //   if ( $("#lockMarkerToAddress").prop("checked") == "false" ) {
    //     return;
    //   }
    //   var street  = $("#location_street").val(),
    //       city    = $("#location_city").val(),
    //       state   = $("#location_state").val(),
    //       postal  = $("#location_postal").val(),
    //       country = $("#location_country").val();
    //   if (street != "" && city != "" && state != "") 
    //   {
    //     PW.maps.reverseGeocode($("#location_lat").val(), $("#location_lng").val(), function(results) {
    //       if (results != undefined && results[0] != undefined) {
    //         var lat = results[0].geometry.location.lat(),
    //             lng = results[0].geometry.location.lng();
    //         marker.setPosition(new google.maps.LatLng(lat,lng));
    //       };
    //     });
    //   };
    // });
    /**
    * watch the markers position
    */
    var marker_to_lat_listener = google.maps.event.addListener(marker, 'position_changed', function() {
      $("#location_lat").val(marker.getPosition().lat());
      $("#location_lng").val(marker.getPosition().lng());
      // Reverse geocode
      // if ( $("#lockMarkerToAddress").prop("checked") ) {
      //   PW.maps.reverseGeocode($("#location_lat").val(), $("#location_lng").val(), function(results) {
      //     if (results != undefined && results[0] != undefined) {
      //       var address = PW.maps.google.toUSAAddress(results[0]);
      //       $("#location_street").val(address['street']);
      //       $("#location_city").val(address['city']);
      //       $("#location_state").val(address['state']);
      //       $("#location_postal").val(address['postal']);
      //       $("#location_country").val(address['country']);
      //     };
      //   });
      // };
    });
    /**
    * Lock/Unlock the lat/lng textfields.
    **/
    $("#lockLatLng").change(function() {
      if ( $("#lockLatLng").prop("checked") )
        $("#location_lat, #location_lng").removeClass("disabled");
      else
        $("#location_lat, #location_lng").addClass("disabled");
    });
    /**
    * Update map when lat/lng textfields update
    **/
    $("#location_lat, #location_lng").change(function() {
      var latLng = new google.maps.LatLng( $("#location_lat").val(), $("#location_lng").val() );
      marker.setPosition(latLng);
      map.setCenter(latLng);
    });
    
    // end init_form
  }

};