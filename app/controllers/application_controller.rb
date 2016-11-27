class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Handle authorization exceptions
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    if request.xhr?
      if signed_in?
        render json: {:status => :error, :message => "You don't have permission to #{exception.action} #{exception.subject.class.to_s.pluralize}"}, :status => 403
      else
        render json: {:status => :error, :message => "You must be logged in to do that!"}, :status => 401
      end
    else
      redirect_to root_url, :alert => exception.message
      # render :file => "public/401.html", :status => :unauthorized
    end
  end
  
  # Redirect to iPhone app
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      # If it's an iPhone and the REFERER is blank the request came from the app
      if request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/] and request.env["HTTP_REFERER"].blank?
        "skateparks://home?user_id=#{resource.id}&authentication_token=#{resource.authentication_token}"
      else
        request.env['omniauth.origin'] || root_url
      end
    else
      super
    end
  end
  
  before_filter :mock_ip_address
  
  # For mocking your ip address in test and dev
  def mock_ip_address
    if Rails.env == 'development' || Rails.env == 'cucumber' || Rails.env == 'test'
      test_ip = ENV['RAILS_TEST_IP_ADDRESS']
      unless test_ip.nil? or test_ip.empty?
        request.instance_eval <<-EOS
          def ip
            "#{test_ip}"
          end
        EOS
      end
    end
  end
    
    
end
