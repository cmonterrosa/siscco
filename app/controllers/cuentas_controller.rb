class CuentasController < ApplicationController
  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @cuentas = Cuenta.find(:all)
  end

  def show
    @cuenta = Cuenta.find(params[:id])
  end

  def new
    @cuenta = Cuenta.new
  end

  def create
    inserta_registro(Cuenta.new(params[:cuenta]), 'Registro creado satisfactoriamente')
  end

  def edit
    @cuenta = Cuenta.find(params[:id])
  end

  def update
    actualiza_registro(Cuenta.find(params[:id]), params[:cuenta])
  end

  def destroy
    Cuenta.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
          #-- Ajax --
  def live_search
    @cuentas = Cuenta.find(:all, :conditions => [" iEjer like ?", "%#{params[:searchtext]}%"])
    return render(:partial => 'filtrocuenta', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --
end
