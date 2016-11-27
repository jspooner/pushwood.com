// Events Controller
PW.controllers.elo = {
  
  init: function() {
    // controller-wide code
  },
  
  locations: function() {
    $("#battle a.btn-vote").click(function(e){
      var winner      = $(e.currentTarget);
      var looser      = null;
      var competitors = $(".btn-vote");
      $.each(competitors,function(index, elem){
        var competitor = $(elem);
        if (competitor.attr("id") != winner.attr("id")) {
          looser = competitor;
        }
      });

      $("input#winner_id").val( winner.attr("id") );
      $("input#loser_id").val( looser.attr("id") );
      $("form#elo").submit();
    });
    
    $("a#elo_draw").click(function(e){
      $("input#draw").val(true);
      $("form#elo").submit();
    });
    
  }

};