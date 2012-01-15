// This file sets up the basic object literals for the application.
PW = {
  models: {},
  controllers: {},
  views: {}
};

// IE Console Handling
// Create a console object if the browser does not have one
if( !window.console ){
  window.console = {
    log: function(){},
    info: function(){},
    warn: function(){},
    error: function(){},
    group: function(){},
    groupEnd: function(){}
  };
}
else if( !window.console.group ){
  window.console.group = window.console.log;
  window.console.groupEnd = function(){};
}
