module Admin
  #
  # Provide authoriztion method for all admin controllers.
  #
  class BaseController < ApplicationController
    layout 'admin'
    before_filter :verify_admin
    
    def current_ability
      @current_ability ||= AdminAbility.new(current_user)
    end
    
    private
    
    def verify_admin
      redirect_to root_url unless current_user && current_user.role?(:admin)
    end
      
  end
end