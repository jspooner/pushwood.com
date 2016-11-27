class CdPagesController < ApplicationController
  # GET /cd_pages
  # GET /cd_pages.xml
  def index
    @cd_pages = CdPage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cd_pages }
    end
  end

  # GET /cd_pages/1
  # GET /cd_pages/1.xml
  def show
    @cd_page = CdPage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cd_page }
    end
  end

  # GET /cd_pages/new
  # GET /cd_pages/new.xml
  def new
    @cd_page = CdPage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cd_page }
    end
  end

  # GET /cd_pages/1/edit
  def edit
    @cd_page = CdPage.find(params[:id])
  end

  # POST /cd_pages
  # POST /cd_pages.xml
  def create
    @cd_page = CdPage.new(params[:cd_page])

    respond_to do |format|
      if @cd_page.save
        format.html { redirect_to(@cd_page, :notice => 'Cd page was successfully created.') }
        format.xml  { render :xml => @cd_page, :status => :created, :location => @cd_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cd_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cd_pages/1
  # PUT /cd_pages/1.xml
  def update
    @cd_page = CdPage.find(params[:id])

    respond_to do |format|
      if @cd_page.update_attributes(params[:cd_page])
        format.html { redirect_to(@cd_page, :notice => 'Cd page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cd_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cd_pages/1
  # DELETE /cd_pages/1.xml
  def destroy
    @cd_page = CdPage.find(params[:id])
    @cd_page.destroy

    respond_to do |format|
      format.html { redirect_to(cd_pages_url) }
      format.xml  { head :ok }
    end
  end
end
