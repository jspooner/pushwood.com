class IphoneController < ApplicationController
  
  layout 'iphone'
  
  def feed
    @images = Image.order("updated_at DESC").limit(10)
  end

end
