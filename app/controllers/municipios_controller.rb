class MunicipiosController < ApplicationController
     before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @municipio_pages, @municipios = paginate :municipios, :per_page => 10
  end

  def show
    @municipio = Municipio.find(params[:id])
  end

  def new
    @municipio = Municipio.new
  end

  def create
    @municipio = Municipio.new(params[:municipio])
    if @municipio.save
      flash[:notice] = 'Municipio was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @municipio = Municipio.find(params[:id])
  end

  def update
    @municipio = Municipio.find(params[:id])
    if @municipio.update_attributes(params[:municipio])
      flash[:notice] = 'Municipio was successfully updated.'
      redirect_to :action => 'show', :id => @municipio
    else
      render :action => 'edit'
    end
  end

  def destroy
    Municipio.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
