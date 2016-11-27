// Events Controller
PW.controllers.admin_images = {
  init: function() 
  {
    // controller-wide code
  },
  index: function() 
  {
    // controller-wide code
    $('form').on('ajax:success', function(event, elements) {
      $(this).parents(".imageHolder").remove();
    });
  }

};