class Api::V2::AuthenticationController < API::V2::BaseController

  def create
    fb_user          = params[:facebook_user]
    @user            = User.find_by_email(fb_user[:email]) || User.new
    @user.email      = fb_user[:email] unless fb_user[:email].nil?
    @user.gender     = fb_user[:gender] unless fb_user[:gender].nil?
    @user.first_name = fb_user[:first_name] unless fb_user[:first_name].nil?
    @user.last_name  = fb_user[:last_name] unless fb_user[:last_name].nil?
    # 
    if authentication = @user.authentications.find_by_provider_and_uid('facebook', fb_user['id'])
      authentication.update_attribute(:token, params[:facebook_token]) if params[:facebook_token]
    else
      @user.authentications.build(:provider => 'facebook', :uid => fb_user['id'], :token => params[:facebook_token])
    end
    
    if @user.save
      render :show
    else
      render :json => @user.errors, status => :unprocessable_entity
    end
  end

end
