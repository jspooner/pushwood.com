class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      # If it's an iPhone and the REFERER is blank the request came from the app
      if request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/] and request.env["HTTP_REFERER"].blank?
        "skateparks://?user_id=#{resource.id}&authentication_token=#{resource.authentication_token}"
      else
        request.env['omniauth.origin'] || root_url
      end
    else
      super
    end
  end
  
end
