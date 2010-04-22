class GarantiasController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @garantia_pages, @garantias = paginate :garantias, :per_page => 10
  end

  def show
    @garantia = Garantia.find(params[:id])
  end

  def new
    @garantia = Garantia.new
  end

  def create
    @garantia = Garantia.new(params[:garantia])
    if @garantia.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @garantia = Garantia.find(params[:id])
  end

  def update
    @garantia = Garantia.find(params[:id])
    if @garantia.update_attributes(params[:garantia])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @garantia
    else
      render :action => 'edit'
    end
  end

  def destroy
    Garantia.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
