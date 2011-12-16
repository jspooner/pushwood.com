class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    omniauth       = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      # TODO If the user is not logged in and they attempt to signin with a different source 
      # we need to find their email address so we can join their accounts.
      # TODO: fix twitter and openID
      email = ""
      if omniauth['provider'] == "facebook"
        email      = omniauth['extra']['user_hash']['email']
        gender     = omniauth['extra']['user_hash']['gender']
        first_name = omniauth['extra']['user_hash']['first_name']
        last_name  = omniauth['extra']['user_hash']['last_name']
      elsif omniauth['provider'] == "google"
        email = omniauth['user_info']['email']
      end
      
      user = User.find_by_email(email) || User.new
      user.gender     = gender unless gender.nil?
      user.first_name = first_name unless first_name.nil?
      user.last_name  = last_name unless last_name.nil?
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
    
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
