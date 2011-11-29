PW.controllers.admin = {
  init: function() 
  {
    
    
  },
  
  parkskaters: function()
  {
    var markers=[];
    var map;
    $(".topbar").append("<div id='admin_map'>")
    showMap = function() {
      var carmelvalley = new google.maps.LatLng(42.7549015, -95.5556282); 
      var map, marker;
      var markersArray = [];
      var myOptions = {
        zoom: 12,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      map = new google.maps.Map(document.getElementById("admin_map"), myOptions);
      map.setCenter(carmelvalley);
      
      $("#parklist li").each(function(x, item){
        var lat = $(item).attr("data-lat");
        var lng = $(item).attr("data-lng");
        var marker = new google.maps.Marker({ map: map, draggable: false, title:'TITLE', position: new google.maps.LatLng(lat, lng) });
        $(item).attr("data-marker-id",markers.length);
        markers.push(marker);
      });
      $("#parklist li").click(function(e){
        var marker = markers[$(e.currentTarget).attr("data-marker-id")];
        map.setCenter(marker.getPosition());
        map.setZoom(19);
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
  
  skateparkcom: function()
  {
    this.parkskaters();
  }
  
}