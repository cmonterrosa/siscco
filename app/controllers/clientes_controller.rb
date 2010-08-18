class ClientesController < ApplicationController
  # before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @clientes = Cliente.find(:all, :order => 'paterno')
  end

  def show
    @cliente = Cliente.find(params[:id])
    @negocio = Negocio.find(:first, :conditions => ["cliente_id = ?", params[:id]])
    @civiles = Civil.find(:all)
    @escolaridades = Escolaridad.find(:all)
    @viviendas = Vivienda.find(:all)
  end

  def new
    @cliente = Cliente.new
    @negocio = Negocio.new
    @grupo = Grupo.new
  end

  def create
    inserta_cliente(Cliente.new(params[:cliente]), Negocio.new(params[:negocio]),  'Registro creado satisfactoriamente.')
  end

  def edit
    @cliente = Cliente.find(params[:id])
    @negocio = Negocio.find(:first, :conditions => ["cliente_id = ?", params[:id]])
    @civiles = Civil.find(:all)
    @escolaridades = Escolaridad.find(:all)
    @viviendas = Vivienda.find(:all)
  end

  def editc
    @cliente = Cliente.find(params[:id])
    @civiles = Civil.find(:all)
    @escolaridades = Escolaridad.find(:all)
    @viviendas = Vivienda.find(:all)
  end

  def update
    actualiza_cliente(Cliente.find(params[:id]), params[:cliente], Negocio.find(params[:id_negocio]), params[:negocio], Grupo.find(params[:grupo][:id]))
  end

  def updatec
    @cliente = Cliente.find(params[:id])
    if @cliente.update_attributes(params[:cliente])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @cliente
    else
      render :action => 'edit'
    end
  end

  def destroy
    Cliente.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  #-- Ajax --
  def live_search
      @clientes = Cliente.find(:all, :conditions => "nombre like '%#{params[:searchtext]}%' or
                                                     paterno like '%#{params[:searchtext]}%' or
                                                     materno like '%#{params[:searchtext]}%'")
      return render(:partial => 'filtrocliente', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --

  def estado_cuenta
    
  end

  def historial_grupos
    @cliente = Cliente.find(params[:id])
    @grupos = Clientegrupo.find(:all, :conditions =>["cliente_id = ? ", @cliente.id], :order => "fecha_inicio, fecha_fin")
    render :layout=>"index_1"
  end


  def estado_cuenta_individual
    
  end

  def consultar
    if Cliente.find_by_rfc(params[:cliente][:rfc]) && params[:cliente][:rfc]
      @cliente= Cliente.find_by_rfc(params[:cliente][:rfc])
    else
      flash[:notice]="No existe ese RFC"
      redirect_to :action => "estado_cuenta"
    end
  end

  def consultar_individual
    if Cliente.find_by_rfc(params[:cliente][:rfc]) && params[:cliente][:rfc]
      @cliente= Cliente.find_by_rfc(params[:cliente][:rfc])
    else
      flash[:notice]="No existe ese RFC"
      redirect_to :action => "estado_cuenta"
    end
  end

  def xml
      render :xml => Cliente.find(:all).to_xml
  end
end
