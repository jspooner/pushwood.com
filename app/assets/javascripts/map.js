/**
*
*
**/

PW.maps = {
  reverseGeocode: function(lat,lng, fn) {
    var geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(lat,lng);
    geocoder.geocode({'latLng':latlng}, function(results, status){
      if (status == google.maps.GeocoderStatus.OK) {
        fn(results);
      } else {
        fn(null);
      };
    });
    
  }
  
  
}

PW.maps.google = {
  /**
  * Convert google Object to a USA Address
  * PW.maps.reverseGeocode(39.302753, -84.467662, function(results) { console.log(PW.maps.google.toUSAAddress(results[1])); });
  */
  toUSAAddress: function(address) {
    var usa_components = ['street_number', 'route', 'locality', 'administrative_area_level_1', 'country', 'postal_code'];
    var usa_address    = {};
    for (var x=0; x < usa_components.length; x++) 
    {
      for (var i=0; i < address["address_components"].length; i++) {
        // console.log("         ", address["address_components"][i]['types']);
        for (var j=0; j < address["address_components"][i]['types'].length; j++) {
          if (address["address_components"][i]['types'][j] == usa_components[x]) {
            usa_address[usa_components[x]] = address["address_components"][i]['long_name'];
            // console.log("         ", usa_address[usa_components[x]])
          };
          // console.log("             ", address["address_components"][i]['types'][j] );
        };
      };
      
    };
    return { 
      street: function() { 
        var st = "";
        if(usa_address['street_number'] != undefined) 
          st += usa_address['street_number'];

        if(usa_address['route'] != undefined) 
          st += (" " + usa_address['route']);
          
        return (st == "") ? undefined : st;
      }(),
      city: usa_address['locality'],
      state: usa_address['administrative_area_level_1'],
      postal: usa_address['postal_code'],
      country: usa_address['country'],
      };
  }
  
  
}