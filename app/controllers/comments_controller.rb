class CommentsController < ApplicationController

  def index
    
  end
  
  def create    
    @commentable.comments.create(params[:comment].merge(:commentable_id => @commentable.id, :commentable_type => @commentable.class.name, :user => current_user)) 
    redirect_to @commentable
  end
    
  before_filter :find_commentable

  def find_commentable
    @commentable = Location.find(params[:location_id]) if params[:location_id]
  end
  
end
