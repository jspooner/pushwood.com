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
    @user = User.create(params[:user])
    unless @user
      render :json => {:errors => ["Invalid user"]}, :status => 401
    end
  end

  def exists
    render :text => User.exists?(:email => params[:email]).to_json
  end

end
