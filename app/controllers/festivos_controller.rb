class FestivosController < ApplicationController
   before_filter :login_required
   
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @festivos = Festivo.find(:all, :order => 'fecha')
  end

  def show
    @festivo = Festivo.find(params[:id])
  end

  def new
    @festivo = Festivo.new
  end

  def create
    inserta_registro(Festivo.new(params[:festivo]), 'Registro creado satisfactoriamente')
  end

  def edit
    @festivo = Festivo.find(params[:id])
  end

  def update
    actualiza_registro(Festivo.find(params[:id]), params[:festivo])
  end

  def destroy
    Festivo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
    #-- Ajax --
    def live_search
      @festivos = Festivo.find(:all, :conditions => ["descripcion like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrofestivo', :layout => false) if request.xhr?
   end
   #--- Funciones ajax para filtrado --
end
