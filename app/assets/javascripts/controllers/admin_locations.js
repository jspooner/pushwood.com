// Events Controller
PW.controllers.admin_locations = {
  init: function() 
  {
    // controller-wide code
  },
  index: function() 
  {
    $('ul#multiList').multiSelect({
        unselectOn: 'body',
        keepSelection: true,
    });
    $("a#selectAll").click(function(e){
      $('ul#multiList li').addClass("selected");
    });
    $("a#selectNone").click(function(e){
      $('ul#multiList li').removeClass("selected");
    });
    
    $("a#markVerified, a#markNotVerified").on("mousedown", function(e){
      e.stopImmediatePropagation();
      e.stopPropagation();
      var selected_ids = $('ul#multiList li.selected').map(function(val,i){return $(i).attr("data-location-id");}).get();
      
      function handle_verified_response() {
        $(selected_ids).each(function(index,element){
          var img = $("li[data-location-id="+element+"] img");
          if (!img.hasClass("verified"))
            img.addClass("verified");
        });
      }
      function handle_unverified_response() {
        $(selected_ids).each(function(index,element){
          var img = $("li[data-location-id="+element+"] img");
          img.removeClass("verified");
        });
      }
      
      var data = {};
      var hallaback;
      if ( $(e.currentTarget).attr("id") == "markVerified") {
        data      = { verified_ids: selected_ids.join(',') }
        hallaback = handle_verified_response;
      } else {
        data      = { invalid_ids: selected_ids.join(',') }
        hallaback = handle_unverified_response;
      };
      
      $.post('/admin/locations/multi_update', data,
        function(data) {
          hallaback();
          $('ul#multiList li').removeClass("selected");
        });
      
      return false;
    });
  }

};

