class CreditosController < ApplicationController

#before_filter :login_required
 before_filter :permiso_requerido#, :except =>[ :busca_credito, :historia, :consulta]


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @credito_pages, @creditos = paginate :creditos, :per_page => 10
    @clientes = Cliente.find(:all, :order => "paterno, materno, nombre")
  end

  def show
    @credito = Credito.find(params[:id])
  end

  def menu
    
  end

#--- este metodo solo trae el formulario para la busqueda
  def busca_credito
    
  end


  def historia #--- este metodos trae todos los creditos del cliente
    if params["credito"]["id"]=~/\d+/
      @credito_unico = Credito.find(params["credito"]["id"].to_i)
    end

    if params["credito"]["rfc"]=~/([a-z]|[A-Z])+/
      @cliente = Cliente.find(:first, :conditions => ["rfc = ? ", params["credito"]["rfc"]]) if params["credito"]["rfc"]
      @creditos = @cliente.creditos
    end
end

  #----- Este metodo es el que va a traer el historico de los creditos ---
  def consulta
   @credito = Credito.find(params[:id]) unless params[:id].nil?
   @movimientos= @credito.movimientos
  end


  def resultados

    #@credito = Credito.find(params["credito"]["id"]) if params ["credito"]["id"]
    if params["credito"]["id"]=~/\d+/
      @credito_unico = Credito.find(params["credito"]["id"].to_i)
    end

    if params["credito"]["rfc"]=~/([a-z]|[A-Z])+/
      @cliente = Cliente.find(:first, :conditions => ["rfc = ? ", params["credito"]["rfc"]]) if params["credito"]["rfc"]
      @creditos = @cliente.creditos
    end
  end

#--- este metodo solo trae el formulario para la busqueda
  def movimiento_credito
    
  end

  def new
    @credito = Credito.new
    @clientes = Cliente.find(:all, :order => "paterno, materno, nombre")
    @avales = Aval.find(:all, :order => "paterno, materno, nombre")
  end

  def create
    @credito = Credito.new(params[:credito])
    @credito.liquido = (@credito.importe * (@credito.tasa_interes / 100)) + @credito.importe
    if @credito.save
      flash[:notice] = 'Credito guardado correctamente'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @credito = Credito.find(params[:id])
  end

  def update
    @credito = Credito.find(params[:id])
    if @credito.update_attributes(params[:credito])
      flash[:notice] = 'Credito was successfully updated.'
      redirect_to :action => 'show', :id => @credito
    else
      render :action => 'edit'
    end
  end

  def destroy
    Credito.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
