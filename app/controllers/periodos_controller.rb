class PeriodosController < ApplicationController
  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @periodo_pages, @periodos = paginate :periodos, :per_page => 10
     @periodos = Periodo.find(:all, :order => 'nombre')
  end

  def show
    @periodo = Periodo.find(params[:id])
  end

  def new
    @periodo = Periodo.new
  end

  def create
    inserta_registro(Periodo.new(params[:periodo]), 'Registro creado satisfactoriamente')
  end

  def edit
    @periodo = Periodo.find(params[:id])
  end

  def update
    actualiza_registro(Periodo.find(params[:id]), params[:periodo])
  end

  def destroy
    Periodo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
                 #-- Ajax --
  def live_search
      @periodos = Periodo.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtroperiodo', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --
end
