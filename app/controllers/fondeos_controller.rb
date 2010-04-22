class FondeosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @fondeo_pages, @fondeos = paginate :fondeos, :per_page => 10
  end

  def show
    @fondeo = Fondeo.find(params[:id])
  end

  def new
    @fondeo = Fondeo.new
  end

  def create
    @fondeo = Fondeo.new(params[:fondeo])
    if @fondeo.save
      flash[:notice] = 'Fondeo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @fondeo = Fondeo.find(params[:id])
  end

  def update
    @fondeo = Fondeo.find(params[:id])
    if @fondeo.update_attributes(params[:fondeo])
      flash[:notice] = 'Fondeo was successfully updated.'
      redirect_to :action => 'show', :id => @fondeo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Fondeo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end