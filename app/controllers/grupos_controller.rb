class GruposController < ApplicationController

  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @grupos = Grupo.find(:all, :order => 'nombre')
  end

  def agregar_clientes
     @grupo = Grupo.find(params[:id])
     @clientes = Cliente.find(:all, :order => 'paterno')
     @clientegrupos = Clientegrupo.find(:all, :conditions => ["grupo_id = ? and activo = 1", @grupo.id])
  end

  def show
    @grupo = Grupo.find(params[:id])
    @clientegrupos = Clientegrupo.find(:all, :conditions => ["grupo_id = ? and activo = 1", @grupo.id])
  end

  def new
    @grupo = Grupo.new
  end

  def newgrupo
    @grupo = Grupo.new
    render :layout=>"index_1"
  end

  def create
    inserta_registro(Grupo.new(params[:grupo]), 'Registro creado satisfactoriamente')
  end

  def edit
    @grupo = Grupo.find(params[:id])
  end

  def update
    actualiza_registro(Grupo.find(params[:id]), params[:grupo])
  end

  def destroy
    Grupo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  #--- Metodos para realizar la consulta ---
  def consultar
    @grupo = Grupo.find(params[:grupo][:id])
  end


  #----------- Métodos para agregar y quitar usuarios de un grupo ---------
  def agregar
  #  render :text => "Vamos a agregar al cliente #{params[:id]} en el grupo #{params[:grupo]}"
  #--- Primero validamos si el usuario no es parte de otro grupo ----
  
    #--- primero validaremos si el grupo ya tiene otro credito -----
    @cliente = Cliente.find(params[:id])
    @grupo = Grupo.find(params[:grupo])
    @clientegrupos = Clientegrupo.find(:all, :conditions => ["cliente_id = ? and activo = 1", @cliente.id])
    @grupos=[]
    unless @clientegrupos.empty?
      flash[:notice]="El cliente ya es parte de algun grupo"
      redirect_to :action => "agregar_clientes", :id=>params[:grupo]
    else
      flash[:notice]="El cliente ha sido agregado"
      Clientegrupo.create(:grupo_id=>@grupo.id, :cliente_id=>@cliente.id)
      redirect_to :action => "agregar_clientes", :id=>params[:grupo]
#      #----- si tiene grupos asociados
#      @clientegrupos.each do |cg|
#        @grupos << cg.grupo
#      end
#
#      @grupos.each do |grupo|
#        if grupo.credito.st == 1
#          flash[:notice]="El cliente ya es parte del grupo #{grupo.nombre}"
#          #redirect_to :action => "agregar_clientes", :id=>params[:grupo]
#        end
#      end
#    redirect_to :action => "agregar_clientes", :id=>params[:grupo]
    end

    
  end
  def quitar
    @cliente = Cliente.find(params[:id])
    @clientegrupos = Clientegrupo.find(:all, :conditions => ["cliente_id = ? and activo = 1", @cliente.id])
    @clientegrupos.each do |grupo| grupo.activo=0; grupo.fecha_fin= Time.now; grupo.save! end
    redirect_to :action => "agregar_clientes", :id=>params[:grupo]
  end




  #-- Ajax --
  def live_search
     @grupos = Grupo.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
     return render(:partial => 'filtrogrupo', :layout => false) if request.xhr?
  end

    #-- Ajax --
  def live_search_clientes
      @clientes = Cliente.find(:all, :conditions => "nombre like '%#{params[:searchtext]}%' or
                                                     paterno like '%#{params[:searchtext]}%' or
                                                     materno like '%#{params[:searchtext]}%' ")
      return render(:partial => 'filtrocliente', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --
end