class CivilsController < ApplicationController
  # GET /civils
  # GET /civils.xml
  def index
    @civils = Civil.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @civils }
    end
  end

  # GET /civils/1
  # GET /civils/1.xml
  def show
    @civil = Civil.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @civil }
    end
  end

  # GET /civils/new
  # GET /civils/new.xml
  def new
    @civil = Civil.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @civil }
    end
  end

  # GET /civils/1/edit
  def edit
    @civil = Civil.find(params[:id])
  end

  # POST /civils
  # POST /civils.xml
  def create
    @civil = Civil.new(params[:civil])

    respond_to do |format|
      if @civil.save
        flash[:notice] = 'Civil was successfully created.'
        format.html { redirect_to(@civil) }
        format.xml  { render :xml => @civil, :status => :created, :location => @civil }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @civil.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /civils/1
  # PUT /civils/1.xml
  def update
    @civil = Civil.find(params[:id])

    respond_to do |format|
      if @civil.update_attributes(params[:civil])
        flash[:notice] = 'Civil was successfully updated.'
        format.html { redirect_to(@civil) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @civil.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /civils/1
  # DELETE /civils/1.xml
  def destroy
    @civil = Civil.find(params[:id])
    @civil.destroy

    respond_to do |format|
      format.html { redirect_to(civils_url) }
      format.xml  { head :ok }
    end
  end
end
