class WelcomeController < ApplicationController
  
  caches_page :index
  
  def index
    @near             = Location.near(request.ip).limit(20)
    @recent_locations = Location.order("updated_at DESC").limit(50)
    @images           = Image.order("updated_at DESC").limit(50)
    @comments         = Comment.order("updated_at DESC").limit(50)
  end
  def support
  end
  def terms_of_service
  end
end
