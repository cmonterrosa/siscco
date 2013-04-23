class SucursalsController < ApplicationController
  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @sucursal_pages, @sucursals = paginate :sucursals, :per_page => 10
    @sucursals = Sucursal.find(:all, :order => 'nombre')
  end

  def show
    @sucursal = Sucursal.find(params[:id])
  end

  def new
    @sucursal = Sucursal.new
  end

  def create
    inserta_registro(Sucursal.new(params[:sucursal]), 'Registro creado satisfactorimente')
  end

  def edit
    @sucursal = Sucursal.find(params[:id])
  end

  def update
    actualiza_registro(Sucursal.find(params[:id]), params[:sucursal])
  end

  def destroy
#    Sucursal.find(params[:id]).destroy
#    redirect_to :action => 'list'
    begin
      registro = Sucursal.find(:first, :conditions => ["id = ?", params[:id]])
      registro.destroy
    rescue ActiveRecord::StatementInvalid => error
        flash[:notice] = "No se puede eliminar el registro #{registro.nombre}, existen relaciones con otras tablas"
    end
    redirect_to :action => "list"
  end
  
  def live_search
      @sucursals = Sucursal.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrosucursal', :layout => false) if request.xhr?
  end

end
