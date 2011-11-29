module Admin
  #
  # Provide authoriztion method for all admin controllers.
  #
  class BaseController < ApplicationController
    before_filter :verify_admin
    
    def current_ability
      @current_ability ||= AdminAbility.new(current_user)
    end
    
    private
    
    def verify_admin
      redirect_to root_url unless current_user && (current_user.role?(:admin) or current_user.role?(:root))
    end
      
  end
end