class Api::V1::AuthenticationController < ApplicationController

  # protect_from_forgery :except => :login
  skip_before_filter :verify_authenticity_token
  
  def login
    @user = User.find_by_email(params[:user][:email])
    unless @user
      render :json => {:errors => ["Invalid email"]}, :status => 401
      return
    end
    unless @user.valid_password?(params[:user][:password])
      render :json => {:errors => ["Invalid password"]}, :status => 401
      return
    end
    # render template
  end
  
  def create
    @user                       = User.new
    @user.email                 = params[:email]
    @user.password              = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    
    unless @user.save
      logger.error { "COULD NOT SAVE USER" }
      # render :json => @user.errors.to_json
    end
    logger.info { "USER ID #{@user.id}" }
  end

  def exists
    render :text => User.exists?(:email => params[:email]).to_json
  end

end
