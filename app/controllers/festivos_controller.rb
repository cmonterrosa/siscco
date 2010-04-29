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
#    @festivo_pages, @festivos = paginate :festivos, :per_page => 10
     @festivos = Festivo.find(:all, :order => 'fecha')
  end

  def show
    @festivo = Festivo.find(params[:id])
  end

  def new
    @festivo = Festivo.new
  end

  def create
    @festivo = Festivo.new(params[:festivo])
    if @festivo.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @festivo = Festivo.find(params[:id])
  end

  def update
    @festivo = Festivo.find(params[:id])
    if @festivo.update_attributes(params[:festivo])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @festivo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Festivo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
    #-- Ajax --
    def live_search
#      @estado_pages, @estados = paginate :estado, :per_page => 10
      @festivos = Festivo.find(:all, :conditions => ["descripcion like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrofestivo', :layout => false) if request.xhr?
   end
      #--- Funciones ajax para filtrado --
end
