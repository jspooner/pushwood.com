// Events Controller
PW.controllers.locations = {
  init: function() 
  {
    // controller-wide code
  },
  show: function() {

    $("#showHideHistory").click(function(e){
      $("#historyList").slideToggle();
    });
    // 
    $(".showhide-changes").click(function(e){
      $(e.currentTarget).siblings("ul").toggle();
      return false;
    });
    // Init slideshow
    $("a[rel='imageGroup']").colorbox({slideshow:true});
    // Init rating form
    $('a').live('ajax:complete', function(xhr, status) {
      $("#ratingDisplay").replaceWith(status.responseText);
    });
    // Global callback function for google maps api.
    initialize = function() {
      var geo = $("#geo");
      var myLatlng = new google.maps.LatLng(geo.attr("data-lat"), geo.attr("data-lng"));
      var myOptions = {
        zoom: 21,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.HYBRID,
        mapTypeControlOptions: {
          style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
          position: google.maps.ControlPosition.RIGHT_BOTTOM
        }
      }
      var map    = new google.maps.Map(document.getElementById("map"), myOptions);
      var marker = new google.maps.Marker({
          position: myLatlng, 
          map: map,
          title:"Hello World!"
        });
      var infowindow = new google.maps.InfoWindow({
        content: _.template($("#markerQATemplate").text())({locationId:rails.locationId})
      });
      /*
      * Watch verify marker form
      */
      $('form#markerVoting').live('ajax:complete', function(event, xhr, status) {
        // debugger;
        var msg = $.parseJSON(xhr['responseText']);
        $(this).parents("div.markerQA").replaceWith("<div>"+msg['message']+"</div>");
      });
      infowindow.open(map,marker);
      
    };
      // Load the google maps api
    function loadScript() {
      var script = document.createElement("script");
      script.type = "text/javascript";
      script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initialize";
      document.body.appendChild(script);
    }
    window.onload = loadScript;
  },
  index: function()
  {
  },
  create: function()
  {
    PW.controllers.locations.edit();
  },
  edit: function() 
	{
    // action-specific code
    PW.controllers.locations.init_form();
  },
  'new': function() 
  {
    // action-specific code
    PW.maps.google.userLocation(function(latLng){
      $("#location_lat").val(latLng.lat());
      $("#location_lng").val(latLng.lng());
      PW.controllers.locations.init_form();
    });
    
  },
  init_form: function() 
  {
    // set up image fields
    remove_fields = function(link) {
      $(link).prev("input[type=hidden]").val("1");
      $(link).closest(".field").hide();
    }
    add_fields = function(link, association, content) {
      var new_id = new Date().getTime();
      var regexp = new RegExp("new_" + association, "g")
      $(link).parent().before(content.replace(regexp, new_id));
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
    * watch the markers position
    */
    var marker_to_lat_listener = google.maps.event.addListener(marker, 'position_changed', function() {
      $("#location_lat").val(marker.getPosition().lat());
      $("#location_lng").val(marker.getPosition().lng());
      // Reverse geocode
      if ( $("#lockMarkerToAddress").prop("checked") ) {
        PW.maps.reverseGeocode($("#location_lat").val(), $("#location_lng").val(), function(results) {
          if (results != undefined && results[0] != undefined) {
            var address = PW.maps.google.toUSAAddress(results[0]);
            $("#location_street").val(address['street']);
            $("#location_city").val(address['city']);
            $("#location_state").val(address['state']);
            $("#location_postal").val(address['postal']);
            $("#location_country").val(address['country']);
          };
        });
      };
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