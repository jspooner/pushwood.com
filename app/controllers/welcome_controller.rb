class WelcomeController < ApplicationController
  def index
    @recent_locations = Location.order("updated_at DESC").limit(50)
    @images = Image.order("updated_at DESC").limit(100)
    @comments = Comment.order("updated_at DESC").limit(50)
  end
end
