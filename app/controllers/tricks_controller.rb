class TricksController < ApplicationController
  # GET /tricks
  # GET /tricks.xml
  def index
    @tricks = Trick.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tricks }
    end
  end

  # GET /tricks/1
  # GET /tricks/1.xml
  def show
    @trick = Trick.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trick }
    end
  end

  # GET /tricks/new
  # GET /tricks/new.xml
  def new
    @trick = Trick.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trick }
    end
  end

  # GET /tricks/1/edit
  def edit
    @trick = Trick.find(params[:id])
  end

  # POST /tricks
  # POST /tricks.xml
  def create
    @trick = Trick.new(params[:trick])

    respond_to do |format|
      if @trick.save
        format.html { redirect_to(@trick, :notice => 'Trick was successfully created.') }
        format.xml  { render :xml => @trick, :status => :created, :location => @trick }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trick.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tricks/1
  # PUT /tricks/1.xml
  def update
    @trick = Trick.find(params[:id])

    respond_to do |format|
      if @trick.update_attributes(params[:trick])
        format.html { redirect_to(@trick, :notice => 'Trick was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trick.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tricks/1
  # DELETE /tricks/1.xml
  def destroy
    @trick = Trick.find(params[:id])
    @trick.destroy

    respond_to do |format|
      format.html { redirect_to(tricks_url) }
      format.xml  { head :ok }
    end
  end
end
