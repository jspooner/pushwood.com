class EloController < ApplicationController
  def images
  end

  def locations
    unless $redis.get("#{Rails.env}:location_ids")
      $redis.pipelined do
        $redis.set("#{Rails.env}:location_ids", Location.verified.collect { |l| l.id }) 
        $redis.expire("#{Rails.env}:location_ids",20000)
      end
    end
    locations = JSON.parse($redis.get("#{Rails.env}:location_ids")).shuffle
    @a = Location.find locations.slice!( rand(locations.length) )
    @b = Location.find locations.slice!( rand(locations.length) )
  end
  
  def top_locations
    @locations = Location.verified.order("elo_rank DESC").limit(100).where("elo_rank > 1200")
  end
  
  def vote
    
    if params[:draw] == "true"
      @a = Location.find params[:a_image_id]
      @b  = Location.find params[:b_image_id]
      #elo @a, @b
      @a.elo_draw! @b, {one_way: false}
      notice = "Draw between \"#{@a.name}\" and  \"#{@b.name}\""
      @a.save
      @b.save
    else
      @winner = Location.find params[:winner_id]
      @loser  = Location.find params[:loser_id]
      @winner.elo_win! @loser, {one_way: false}
      notice = "You voted for \"#{@winner.name.titleize}\" #{@winner.elo_rank}"
      @winner.save
      @loser.save
    end
    
    # render :text => params
    # render :text => "winner #{@winner.name} #{@winner.elo_rank}"
    redirect_to(battles_skateparks_path, :notice => notice )
  end
  
  private
  
    def random(klass)
      klass.offset(rand(klass.count)).first
    end
    
    def elo winner, loser
      winner.elo_win! loser, {one_way: false}
    end
    
    def elo_draw a, b
      a.elo_draw! b, {one_way: false}
    end

end
