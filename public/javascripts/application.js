$(document).ready(function() {
	/**
	* Location Model
	*/
	window.Location = Backbone.Model.extend({
		initialize: function(attributes, options) {
			console.log("Location initalize ");
			var loc = attributes["location"];
			this.attributes = loc;
			this._previousAttributes = _.clone(this.attributes);
		}
	});
	/**
	* Locations List
	*/	
	window.LocationList = Backbone.Collection.extend({
		model: Location,
		url: '/api/v1/locations.json'
	});
	/**
	* Location <li> View
	*/
	window.LocationViewLI = Backbone.View.extend({
		tagName: "li",
		template: _.template('<a href="/locations/<%= id %>"><%= name %></a>'),
		events: {
			"click a": "handleClick"
		},
		initialize: function() {
			console.log("LocationViewLI initalize", this.model);
			this.render();
		},
		handleClick: function(event) {
			event.preventDefault();
			console.log("LocationViewLI handleClick", this.model.escape("name") );
			new LocationViewForm({model:this.model});
		},
		render: function() {
			console.log("LocationViewLI render", this.model.escape("name") );
			$(this.el).html(this.template(this.model.toJSON()));
			$('#location-list').append(this.el);
			return this;
    }
	});
	/**
	* Location <li> Form
	*/
	window.LocationViewForm = Backbone.View.extend({
		tagName: "form",
		template: _.template('<h1>Editing <%= name %></h1>'),
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
			$(this.el).html(this.template(this.model.toJSON()));
			$('#location-form').empty();
			$('#location-form').append(this.el);
			return this;
    }
	});
	/**
	* Application View
	*/
	window.AppView = Backbone.View.extend({
		el:$('#locationapp'),
		events: {
			"list" : "render"
		},
		initialize: function() 
		{
			console.log("AppView initialize");
			// _.bindAll(this, 'render');
			Locations.bind('all', this.render);	
			Locations.fetch();
		},
		render: function() 
		{
			console.log("AppView render");
			Locations.each(function(item) {
				new LocationViewLI({model:item});
			});


		}
	});
	
	window.Locations = new LocationList;
	window.App       = new AppView;
	
});