class WelcomeController < ApplicationController
  def index
    @top_parks     = Location.verified.order("elo_rank DESC").where("elo_rank > 1200").limit(4)
    @recent        = Location.verified.order("updated_at DESC").limit(4)
    @recent_images = Image.approved.limit(24)
    
    @tire = Tire::Search::Search.new(Location.index_name)
    @tire.facet :states, :global => true do |search|
      search.terms :state, :size => 51
      search.facet_filter :term, { :country => "United States" }
    end
    @usa = @tire.results.facets['states']['terms'].sort_by { |h| h["term"] }
  end
  
  def support
  end
  
  def terms_of_service
  end
end
