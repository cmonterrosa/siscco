class CuentasController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @cuenta_pages, @cuentas = paginate :cuentas, :per_page => 10
  end

  def show
    @cuenta = Cuenta.find(params[:id])
  end

  def new
    @cuenta = Cuenta.new
  end

  def create
    @cuenta = Cuenta.new(params[:cuenta])
    if @cuenta.save
      flash[:notice] = 'Cuenta creada correctamente'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @cuenta = Cuenta.find(params[:id])
  end

  def update
    @cuenta = Cuenta.find(params[:id])
    if @cuenta.update_attributes(params[:cuenta])
      flash[:notice] = 'Cuenta actualizada correctamente'
      redirect_to :action => 'show', :id => @cuenta
    else
      render :action => 'edit'
    end
  end

  def destroy
    Cuenta.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
