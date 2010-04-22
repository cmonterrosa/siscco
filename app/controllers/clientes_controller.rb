class ClientesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @cliente_pages, @clientes = paginate :clientes, :per_page => 10
  end

  def show
    @cliente = Cliente.find(params[:id])
  end

  def new
    @cliente = Cliente.new
    #--- Hacemos las consultas para rellenar los combos ----
    @civiles = Civil.find(:all)
    @escolaridades = Escolaridad.find(:all)
    @viviendas = Vivienda.find(:all)
    @colonias = Colonia.find(:all)
    @grupos = Grupo.find(:all)
    #----- Consultas para actualizar dinamicamente los combos --
    @estados = Estado.find(:all, :order => "estado")
    @municipios = Municipio.find(:all, :order => "municipio")
    @ejidos = Ejido.find(:all, :order => "ejido")

  end

  def create
    @cliente = Cliente.new(params[:cliente])
    @negocio = Negocio.new(params[:negocio])
    if @cliente.save and @negocio.save
      flash[:notice] = 'Cliente was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @cliente = Cliente.find(params[:id])
  end

  def update
    @cliente = Cliente.find(params[:id])
    if @cliente.update_attributes(params[:cliente])
      flash[:notice] = 'Cliente was successfully updated.'
      redirect_to :action => 'show', :id => @cliente
    else
      render :action => 'edit'
    end
  end

  def destroy
    Cliente.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  #--- Estas funciones son para manipular el AJAX

  def get_municipios
      @municipios= Municipio.find(:all, :conditions => ["estado_id = ?",params[:lugar_estado_id] ])
      return render(:partial => 'municipios', :layout => false) if request.xhr?
  end


   def get_ejidos
      @ejidos= Ejido.find(:all, :conditions => ["municipio_id = ?",params[:lugar_municipio_id] ])
      return render(:partial => 'ejidos', :layout => false) if request.xhr?
  end

    def get_colonias
      @colonias= Colonia.find(:all, :conditions => ["ejido_id = ?",params[:lugar_ejido_id] ])
      return render(:partial => 'colonias', :layout => false) if request.xhr?
    end




end
