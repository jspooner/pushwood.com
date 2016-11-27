PW.views.locations.photo_gallery = {
  scriptURL: null,
  init: function() {
    $("#photo-buttons a[rel=next], #photo-buttons a[rel=prev]").on("click", function(e) {
      e.stopImmediatePropagation();
      e.stopPropagation();
      
      var url = $(this).attr('href');
      
      if (_gaq != undefined) {
        _gaq.push(['_trackPageview', url]);
      } else {
        console.log("_trackPageview", url);
      }
      
      if (url.indexOf(".js") == -1)
        url = url.split("?page=").join(".js?page=");
      
      PW.views.locations.photo_gallery.scriptURL = url;
      window.addthis = null;
      $.getScript(PW.views.locations.photo_gallery.scriptURL, PW.views.locations.photo_gallery.handlePhotoLoaded);
      
      return false;
    });
  },
  
  handlePhotoLoaded: function(data, textStatus, jqxhr) {
    history.replaceState(null, null, PW.views.locations.photo_gallery.scriptURL.replace(".js","") );
  }
}