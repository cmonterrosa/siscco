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
     @clientegrupos = Clientegrupo.find(:all, :select => "id, grupo_id, cliente_id", :conditions => ["grupo_id = ? and activo = 1", @grupo.id])
     #@clientes = Cliente.find(:all, :order => "paterno")
     @clientes = todos_clientes_singrupo_join
     if @clientes.empty?
       redirect_to :action => "list"
     end
  end

  def show
    @grupo = Grupo.find(params[:id])
    @clientegrupos = Clientegrupo.find(:all, :conditions => ["grupo_id = ?", @grupo.id], :order => "activo")
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
    @grupo = Grupo.find(params[:id])
    @clientegrupos = Clientegrupo.find(:all, :conditions => ["grupo_id = ? ", @grupo.id])
    @clientegrupos.each do |cg| cg.destroy end  
    @grupo.destroy 
    redirect_to :action => 'list'
  end

  #--- Metodos para realizar la consulta ---
  def consultar
    @credito = Credito.find(:first, :conditions =>["grupo_id = ?", params[:grupo][:id] ])
    if @credito
       redirect_to :action => "vencimiento", :controller=>"creditos", :id => @credito
    else
      flash[:notice] = "El grupo aun no tiene creditos asignados"
      redirect_to :action => "estado_cuenta", :controller => "grupos"
    end
  end

  def estado_cuenta
    
  end


  #----------- Métodos para agregar y quitar usuarios de un grupo ---------
  def agregar
    #--- primero validaremos si el grupo ya tiene otro credito -----
    @cliente = Cliente.find(params[:id])
    @grupo = Grupo.find(params[:grupo])
    @clientegrupos = Clientegrupo.find(:all, :select => "id", :conditions => ["cliente_id = ? and activo = 1", @cliente.id])
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
    @clientegrupos = Clientegrupo.find(:all, :select => "id, activo, fecha_fin", :conditions => ["cliente_id = ? and activo = 1", @cliente.id])
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
     if params[:searchtext].size > 3
     @grupo = session["grupo_online"]
     @clientes = Cliente.find_by_sql("select id, rfc, curp, paterno, materno, nombre from clientes where id not in (select c.id from clientes c,
                 clientes_grupos cg where c.id=cg.cliente_id and cg.activo=1) and (nombre like '%#{params[:searchtext].strip}%' or paterno like '#{params[:searchtext].strip}%' or materno like '#{params[:searchtext].strip}%') order by paterno, materno, nombre")
     return render(:partial => 'filtrocliente', :layout => false) if request.xhr?
     else
       render :text => "Teclee cuando menos 3 letras para iniciar la búsqueda por apellidos o nombre"
     end

  end


  def live_search_curp
      if params[:searchcurp].size > 2
          @grupo = session["grupo_online"]
          @clientes = Cliente.find_by_sql("select id, rfc, curp, paterno, materno, nombre from clientes where id not in (select c.id from clientes c, clientes_grupos cg where c.id=cg.cliente_id and activo=1) and (curp like '#{params[:searchcurp].strip}%') order by paterno, materno, nombre")
          #@clientes = Cliente.find_by_sql("select id, rfc, curp, paterno, materno, nombre from clientes where id not in (select c.id from clientes c, clientes_grupos cg where c.id=cg.cliente_id) and (curp like '%#{params[:searchcurp].strip}%') ")
          return render(:partial => 'filtrocliente', :layout => false) if request.xhr?
      else
          render :text => "Teclee cuando menos 2 letras para iniciar la búsqueda por curp"
      end
  end

end
