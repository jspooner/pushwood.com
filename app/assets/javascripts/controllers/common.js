// Application-wide code to be executed on DOMReady
PW.controllers.common = {
  init: function() {
    // application-wide code

		$('.nav').dropdown();
		$('a.close').click(function(){
			$(".alert-message").hide();
		});
		
		$("a[rel*='external']").click(function(){
			pageTracker._trackPageview('/outgoing/'+ $(this).attr('href'));
		});
  }
};