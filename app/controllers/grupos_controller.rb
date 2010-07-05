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
#    @grupo_pages, @grupos = paginate :grupos, :per_page => 10
     @grupos = Grupo.find(:all, :order => 'nombre')
  end

  def show
    @grupo = Grupo.find(params[:id])
  end

  def new
    @grupo = Grupo.new
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

  def estado_cuenta

  end

  def consultar
    @grupo = Grupo.find(params[:grupo][:id])
  end


   #-- Ajax --
   def live_search
      @grupos = Grupo.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrogrupo', :layout => false) if request.xhr?
   end
      #--- Funciones ajax para filtrado --
end
