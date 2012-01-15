class Admin::ImagesController < Admin::BaseController
  respond_to :html, :json
  def index
    @unapproved = Image.unapproved
    respond_with(@unapproved)
  end

  def update
    @image = Image.find(params[:id])
    flash[:notice] = "Sucessfuly approved" if @image.update_attributes(params[:image])
    respond_with(@image) do |format|
      format.html { redirect_to admin_images_path }
      format.json { render :json => @image.to_json }
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to(admin_images_url) }
      format.json  { head :ok }
    end
    
  end

end
