// http://www.viget.com/inspire/extending-paul-irishs-comprehensive-dom-ready-execution/
UTIL = {
  exec: function( controller, action ) {
    var ns = PW.controllers,
        action = ( action === undefined ) ? "init" : action;

    if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) {
      console.group('UTIL.init: ACTIVE.controllers.%s.%s()', controller, action);
      ns[controller][action]();
      console.groupEnd();
    }
  },

  init: function() {
    var body = document.body,
        controller = body.getAttribute( "data-controller" ),
        action = body.getAttribute( "data-action" );

    UTIL.exec( "common" );
    UTIL.exec( controller );
    UTIL.exec( controller, action );
  }
};

$( document ).ready( UTIL.init );
