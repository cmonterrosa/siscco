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

  def nuevo
    @credito=Credito.find(params[:credito])
    @tipos = %w{ABONO CARGO}
    return render(:partial => 'nuevoabono', :layout => false, :credito=>params[:credito]) if request.xhr?
  end


  def create
    #valor= params[:movimiento].delete(:tipo)
    @movimiento = Movimiento.new(params[:movimiento])
    #@movimiento.credito = Credito.find(params[:credito])
    
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
#    Movimiento.find(params[:id]).destroy
#    redirect_to :action => 'list'
    begin
      registro = Movimiento.find(:first, :conditions => ["id = ?", params[:id]])
      registro.destroy
    rescue ActiveRecord::StatementInvalid => error
        flash[:notice] = "No se puede eliminar el registro #{registro.nombre}, existen relaciones con otras tablas"
    end
    redirect_to :action => "list"
  end
end
