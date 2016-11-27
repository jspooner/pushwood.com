class API::V2::BaseController < ApplicationController
  before_filter :authenticate
  
  protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "mimi" && password == "knoop"
      end
    end
  
end