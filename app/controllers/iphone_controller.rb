class IphoneController < ApplicationController
  
  layout 'iphone'
  
  def feed
    @images = Image.order("updated_at DESC").limit(10)
  end
  
  def your_images
    @images = current_user.images.limit(10) rescue []
  end
  
  def news
  end
  
  def help
    render text: "<h1>Help</h1>"
  end
  def about
    render text: "<h1>About</h1>"
  end
  
end
