class LineasController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @linea_pages, @lineas = paginate :lineas, :per_page => 10
  end

  def show
    @linea = Linea.find(params[:id])
  end

  def new
    @linea = Linea.new
    # ---- carga combos -----
    @fondeos = Fondeo.find(:all, :order => 'fuente')
    @status = Statu.find(:all, :order => 'statu')
  end

  def create
    @linea = Linea.new(params[:linea])
    if @linea.save
      flash[:notice] = 'Linea was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @linea = Linea.find(params[:id])
  end

  def update
    @linea = Linea.find(params[:id])
    if @linea.update_attributes(params[:linea])
      flash[:notice] = 'Linea was successfully updated.'
      redirect_to :action => 'show', :id => @linea
    else
      render :action => 'edit'
    end
  end

  def destroy
    Linea.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end