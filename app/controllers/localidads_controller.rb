class LocalidadsController < ApplicationController
     before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @localidad_pages, @localidads = paginate :localidads, :per_page => 10
  end

  def show
    @localidad = Localidad.find(params[:id])
  end

  def new
    @localidad = Localidad.new
  end

  def create
    @localidad = Localidad.new(params[:localidad])
    if @localidad.save
      flash[:notice] = 'Localidad was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @localidad = Localidad.find(params[:id])
  end

  def update
    @localidad = Localidad.find(params[:id])
    if @localidad.update_attributes(params[:localidad])
      flash[:notice] = 'Localidad was successfully updated.'
      redirect_to :action => 'show', :id => @localidad
    else
      render :action => 'edit'
    end
  end

  def destroy
    Localidad.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
