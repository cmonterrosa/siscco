class EstadosController < ApplicationController
   before_filter :login_required
   
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @estado_pages, @estados = paginate :estados, :per_page => 10
     @estados = Estado.find(:all, :order => 'estado')
  end

  def show
    @estado = Estado.find(params[:id])
  end

  def new
    @estado = Estado.new
  end

  def create
    inserta_registro(Estado.new(params[:estado]), 'Registro creado satisfactoriamente')
  end

  def edit
    @estado = Estado.find(params[:id])
  end

  def update
    actualiza_registro(Estado.find(params[:id]), params[:Estado])
  end

  def destroy
    Estado.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  #-- Ajax --
    def live_search
#      @estado_pages, @estados = paginate :estado, :per_page => 10
      @estados = Estado.find(:all, :conditions => ["estado like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtroestado', :layout => false) if request.xhr?
   end
      #--- Funciones ajax para filtrado --
end
