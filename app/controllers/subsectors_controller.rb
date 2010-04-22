class SubsectorsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @subsector_pages, @subsectors = paginate :subsectors, :per_page => 10
  end

  def show
    @subsector = Subsector.find(params[:id])
  end

  def new
    @subsector = Subsector.new
#    ---- llena combo sector ----
    @sectores = Sector.find(:all, :order => "sector")
  end

  def create
    @subsector = Subsector.new(params[:subsector])
    if @subsector.save
      flash[:notice] = 'Subsector was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @subsector = Subsector.find(params[:id])
  end

  def update
    @subsector = Subsector.find(params[:id])
    if @subsector.update_attributes(params[:subsector])
      flash[:notice] = 'Subsector was successfully updated.'
      redirect_to :action => 'show', :id => @subsector
    else
      render :action => 'edit'
    end
  end

  def destroy
    Subsector.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
