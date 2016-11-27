class Admin::LocationsController < ApplicationController
  respond_to :html, :json
  layout "admin"

  def index
    params[:page] = 1 unless params.has_key? :page
    @locations = Location.paginate(:page => params[:page], :per_page => 100).where("country = 'United States'").order("city ASC")
    respond_with(:admin, @locations)
  end
  
  def multi_update
    verified = Admin::Location.markers_have_been_verified params[:verified_ids].split(",") if params[:verified_ids]
    invalid = Admin::Location.markers_have_been_invalidated params[:invalid_ids].split(",") if params[:invalid_ids]
    render :json => { verified: verified, invalid: invalid }
  end
  
end
