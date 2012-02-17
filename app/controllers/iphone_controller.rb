class IphoneController < ApplicationController
  
  layout 'iphone'
  
  def feed
    @images = Image.order("updated_at DESC").limit(10)
  end
  
  def your_images
    @images = current_user.images.limit(10)
  end

end
