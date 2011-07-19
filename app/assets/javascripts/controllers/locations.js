// Events Controller
PW.controllers.locations = {
  init: function() 
	{
    // controller-wide code
		/**
		* Location Model
		*/
		window.Location = Backbone.Model.extend({
			name: 'location',
			initialize: function(attributes, options) {
				this.set(attributes["location"], {silent : true});
		    this._previousAttributes = _.clone(this.attributes);
			}
		});
		/**
		* Locations List
		*/	
		window.LocationList = Backbone.Collection.extend({
			model: Location,
			url: '/api/v1/locations.json?city=San Diego'
		});
		// END INIT
  },

  /**
	* 
	**/
  index: function()
	{
		
		function listItem(markerImg, name, address, phone, url) {
			var div = $("<div></div>");
			var a = $("<a>"+name+"</a>");
			a.attr("href", url);
			div.append($("<h2 style='display:inline'></h2>").append($('<img src="'+markerImg+'" />')).append(a) );

			div.append( $('<a style="color:red;" href="'+url+'/edit">edit</a>'));

			div.append($("<p>"+address+"</p>"));
			div.append($("<p>"+phone+"</p>"));
			return div;
		}		
					
		
		// google.maps.event.addListener(map, 'idle', function() {
		// 	
		// 	var bounds = map.getBounds();
		// 	$.getJSON('/api/v1/locations.json?bounding_box='+bounds.toUrlValue(), function(data) {
		// 		// remove
		// 	  $("#location_list").empty();
		// 	  if (markersArray) {
		// 	    for (i in markersArray) {
		// 	      markersArray[i].setMap(null);
		// 	    }
		// 	    markersArray.length = 0;
		// 	  }
		// 		
		// 		// add
		// 		for (var i=0; i < data.length; i++) {
		// 			var marker = new google.maps.Marker({ map: map,	draggable: true, title:data[i]['location']['name'], position: new google.maps.LatLng(data[i]['location']['lat'], data[i]['location']['lng']) });
		// 			marker.setIcon( iconFor(i) );
		// 			
		// 			function foo(map,marker,location) {
		// 				var contentString = '<div id="content">'+
		// 				    '<div id="siteNotice">'+
		// 				    '</div>'+
		// 				    '<h1 id="firstHeading" class="firstHeading">'+location['name']+'</h1>'+
		// 				    '<div id="bodyContent">'+
		// 				    '<p>' + location['street'] +
		// 				    '</p>'+
		// 				    '</div>'+
		// 				    '</div>';
		// 				var infowindow = new google.maps.InfoWindow({content:contentString, disableAutoPan:true});
		// 				google.maps.event.addListener(marker, 'click', function() {
		// 				  infowindow.open(map,marker);
		// 				});
		// 			}
		// 			foo(map,marker,data[i]['location']);
		// 			
		// 			markersArray.push(marker);
		// 			$("#location_list").append( 
		// 				listItem(
		// 					iconFor(i),
		// 					data[i]['location']['name'], 
		// 					data[i]['location']['street'], 
		// 					data[i]['location']['phone'],
		// 					"locations/" + data[i]['location']['id']
		// 				 ) );
		// 		};
		// 						
		// 	});
		// 	
		// 	  });
		// 
		// Try W3C Geolocation (Preferred)

		// End Map
		/**
		* Location <li> View
		*/
		window.LocationViewLI = Backbone.View.extend({
			tagName: "div",
			className: "location_item clearfix",
			template: _.template(JST.location_item),
			events: {
				"click a": "handleClick"
			},
			initialize: function(args) {
				this.index      = args['index'];
				this.markerIcon = args['markerIcon'];
				this.render();
			},
			handleClick: function(event) {
				// event.preventDefault();
			},
			render: function() {
				var json   = this.model.toJSON();
				json['markerIcon'] = this.markerIcon;
				json['index'] = this.index;
				$(this.el).html(this.template(json));
				$('#location_list').append(this.el);
				return this;
	    }
		});
		/**
		* Map View
		*/
		window.MapView = Backbone.View.extend({
			el:$('#map_canvas'),
			markers:[],
			events: {},
			initialize: function()
			{
				_.bindAll(this, 'handle_resize', 'reload_locations');
				var that = this;
				var resizeTimer;
				$(window).resize(function() {
				    clearTimeout(resizeTimer);
				    resizeTimer = setTimeout(that.handle_resize, 60, that);
				});
				// init map
				var carmelvalley = new google.maps.LatLng(32.94803512647807, -117.23739940536501); 
				var map;
				var marker;
				var markersArray = [];
			  var myOptions = {
			    zoom: 12,
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			  };
			  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
				map.setCenter(carmelvalley);
				if(navigator.geolocation) {
			    browserSupportFlag = true;
			    navigator.geolocation.getCurrentPosition(function(position) {
			      initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
			      map.setCenter(initialLocation);
			    }, function() {
			      handleNoGeolocation(browserSupportFlag);
			    });
			  // Try Google Gears Geolocation
			  } else if (google.gears) {
			    browserSupportFlag = true;
			    var geo = google.gears.factory.create('beta.geolocation');
			    geo.getCurrentPosition(function(position) {
			      initialLocation = new google.maps.LatLng(position.latitude,position.longitude);
			      map.setCenter(initialLocation);
			    }, function() {
			      handleNoGeoLocation(browserSupportFlag);
			    });
			  // Browser doesn't support Geolocation
			  } else {
			    browserSupportFlag = false;
			    handleNoGeolocation(browserSupportFlag);
			  };

				function handleNoGeolocation(errorFlag) {
			    if (errorFlag == true) {
			      alert("Geolocation service failed.");
			      initialLocation = carmelvalley;
			    } else {
			      alert("Your browser doesn't support geolocation. We've placed you in Siberia.");
			      initialLocation = carmelvalley;
			    }
			    map.setCenter(initialLocation);
			  }
				
				this.map = map; 
				google.maps.event.addListener(map, "dragend", this.reload_locations);
				// google.maps.event.addListener(map, "bounds_changed", this.reload_locations);
				this.render();
				// END INITIALIZE
			},
			render: function()
			{
				Locations.bind('all', this.display_results);
				this.handle_resize();
				return this;
			},
			handle_resize: function(mapView)
			{
				console.log("handle_resize", this); // DOMWindow VS. MapView
				var rWidth = $(window).width() - $("#location_list").width();
				var rHeight = $(window).height() - $("#location_list").position()['top'] + 10;
				this.el.width(rWidth);
				this.el.height(rHeight);
				$("#locations").height(rHeight);
				console.log("handle_resize", rWidth );
			},
			reload_locations :function()
			{
				console.log("r", this.map );
				var b = this.map.getBounds();
				var sw = [b.getSouthWest().lat(), b.getSouthWest().lng()];
				var ne = [b.getNorthEast().lat(), b.getNorthEast().lng()];
				var q = [sw,ne];
				Locations.url = '/api/v1/locations.json?limit=19&bounds='+q;
				Locations.fetch();
			},
			display_results: function()
			{
				// console.log('display_results' , App.mapView.map);
				function iconFor(i) {
					var alpha = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S"];
					return '/images/markers/blue_Marker'+alpha[i]+'.png';
				}
				//
				var map = App.mapView.map;
				var markersArray = App.mapView.markers;
				$("#location_list").empty();
			  if (markersArray) {
			    for (i in markersArray) {
			      markersArray[i].setMap(null);
			    }
			    markersArray.length = 0;
			  }
				// Display Markers
				var i = 0;
				Locations.each(function(item) {
					var json   = item.toJSON();
					var marker = new google.maps.Marker({ map: map,	draggable: false, title:json['name'], position: new google.maps.LatLng(json['lat'], json['lng']) });
					var markerIcon = iconFor(i); 
					marker.setIcon( markerIcon );
					markersArray.push(marker);
					new LocationViewLI({model:item, markerIcon:markerIcon, index:i});
					i++;
				});												
			}
		})
		/**
		* Application View
		*/
		window.AppView = Backbone.View.extend({
			el:$('#locationapp'),
			initialize: function() 
			{
				console.log("AppView initialize");
				
				this.render();
			},
			render: function() 
			{
				console.log("AppView render");
				this.mapView = new MapView();
				return this;
			},
			handle_mapInit: function()
			{
			}
		});
		window.Locations = new LocationList; // add bounds
		window.App       = new AppView;			

		
		
		
		
		// END INDEX
	},
  foo: function() 
	{
		/**
		* Location <li> Form
		*/
		window.LocationViewForm = Backbone.View.extend({
			tagName: "form",
			template: _.template(JST.edit),
			events: {
				"submit": "handleSubmit"
			},
			initialize: function() {
				console.log("LocationViewForm initalize", this.model);
				this.render();
			},
			handleSubmit: function(event) {
				console.log("LocationViewForm handleSubmit", this.model.escape("name") );
			},
			render: function() {
				console.log("LocationViewForm handleSubmit", this.model.escape("name") );
				var tmpl = $(this.template(this.model.toJSON()));
				tmpl.find("input[type=checkbox]").each(function(index){
					var t = $(this);
					console.log( t );
					if( t.attr("value") == "0") {
						t.removeAttr("checked");
					} else {
						t.attr("checked", "checked" );				
					};
					t.removeAttr("value");
				});
				$('#location-form').empty();
				$('#location-form').append(tmpl);
				return this;
	    }
		});
		// END INDEX
  },

  edit: function() 
	{
    // action-specific code
		PW.controllers.locations.init_form();
		// set up map
    var map, marker;
	  var myOptions = {
	    zoom: 19,
	    mapTypeId: google.maps.MapTypeId.HYBRID
	  };
		
    var lat = $("#location_lat").val();
    var lng = $("#location_lng").val();
    if (lat == "" && lng == "") {
      lat = '33.0532118628684';
      lat = '-117.287725073576';
      // myOptions['zoom'] = 8;
      console.log("SET", lat)
    };
		var centerLocation = new google.maps.LatLng( lat, lng ); 
	  map = new google.maps.Map(document.getElementById("exactLocationMap"), myOptions);
		map.setCenter(centerLocation);
    marker = new google.maps.Marker({ map: map,	draggable: true, position: centerLocation });
    /**
  	* watch the markers position
  	*/

  	var marker_to_lat_listener = google.maps.event.addListener(marker, 'position_changed', function() {
  		$("#location_lat").val(marker.getPosition().lat());
  		$("#location_lng").val(marker.getPosition().lng());  		
  	});
  	
  	// google.maps.event.addListener(marker, 'dragend', function() {
  	//     
  	//       new google.maps.Geocoder().geocode( { 'location': new google.maps.LatLng($("#location_lat").val(), $("#location_lng").val())}, function(results, status) {
  	//         console.log(results);
  	//         console.log(status);
  	//         if (status == google.maps.GeocoderStatus.OK) {
  	//           // results[0].address_components[0]
  	//           debugger;
  	//         }
  	//       });
  	//       
  	//     });
    //
  },

  new: function() 
	{
    // action-specific code
		PW.controllers.locations.init_form();
    // PW.controllers.locations.edit();
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

	  // end init_form
  }

};