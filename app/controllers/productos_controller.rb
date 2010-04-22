class ProductosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @producto_pages, @productos = paginate :productos, :per_page => 10
  end

  def show
    @producto = Producto.find(params[:id])
  end

  def new
    @producto = Producto.new
    # ------ llena combos ------
    @grupos = Grupo.find(:all)
    @periodos = Periodo.find(:all)
  end

  def create
    @producto = Producto.new(params[:producto])
    if @producto.save
      flash[:notice] = 'Producto was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @producto = Producto.find(params[:id])
    @grupos = Grupo.find(:all)
    @periodos = Periodo.find(:all)
  end

  def update
    @producto = Producto.find(params[:id])
    if @producto.update_attributes(params[:producto])
      flash[:notice] = 'Producto was successfully updated.'
      redirect_to :action => 'show', :id => @producto
    else
      render :action => 'edit'
    end
  end

  def destroy
    Producto.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
