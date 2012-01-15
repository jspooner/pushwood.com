// Events Controller
PW.controllers.admin_images = {
  init: function() 
  {
    // controller-wide code
  },
  index: function() 
  {
    // controller-wide code
    $('form').live('ajax:success', function(event, elements) {
      $(this).parent(".imageHolder").remove();
    });
  }

};