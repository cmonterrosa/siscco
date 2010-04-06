class RegionsController < ApplicationController
     before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @region_pages, @regions = paginate :regions, :per_page => 10
  end

  def show
    @region = Region.find(params[:id])
  end

  def new
    @region = Region.new
  end

  def create
    @region = Region.new(params[:region])
    if @region.save
      flash[:notice] = 'Region was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @region = Region.find(params[:id])
  end

  def update
    @region = Region.find(params[:id])
    if @region.update_attributes(params[:region])
      flash[:notice] = 'Region was successfully updated.'
      redirect_to :action => 'show', :id => @region
    else
      render :action => 'edit'
    end
  end

  def destroy
    Region.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
