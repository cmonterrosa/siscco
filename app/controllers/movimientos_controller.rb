class MovimientosController < ApplicationController
     before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @movimiento_pages, @movimientos = paginate :movimientos, :per_page => 10
  end

  def aplicar
    #@credito = Credito.find(params[:credito][:id]) if params[:credito][:id] != ""
   @credito = Credito.find(params[:id]) unless params[:id].nil?
  end

  def show
    @movimiento = Movimiento.find(params[:id])
  end

  def new
    @movimiento = Movimiento.new
    
  end

  def create
    if params[:movimiento][:tipo] == "ABONO"
      params[:movimiento][:abono] = params[:movimiento][:importe]
    else
      params[:movimiento][:cargo] = params[:movimiento][:importe]
    end
    valor= params[:movimiento].delete(:tipo)

    @movimiento = Movimiento.new(params[:movimiento])
    @movimiento.credito = Credito.find(params[:credito])
    if @movimiento.save
      flash[:notice] = 'El Movimiento ha sido aplicado correctamente'
      #redirect_to :action => 'aplicar', :id => @movimiento.credito
      #Nos vamos a esta ruta: http://localhost:3000/creditos/consulta
       redirect_to :controller => "creditos", :action => 'consulta', :id => @movimiento.credito

    else
      render :action => 'new'
    end
  end

  def edit
    @movimiento = Movimiento.find(params[:id])
  end

  def update
    @movimiento = Movimiento.find(params[:id])
    if @movimiento.update_attributes(params[:movimiento])
      flash[:notice] = 'Movimiento actualizado.'
      redirect_to :action => 'show', :id => @movimiento
    else
      render :action => 'edit'
    end
  end

  def destroy
    Movimiento.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
