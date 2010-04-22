class CreditosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @credito_pages, @creditos = paginate :creditos, :per_page => 10
  end

  def show
    @credito = Credito.find(params[:id])
  end

  def new_grupal
    @credito = Credito.new
    #---- Para rellenar las queries----
    @lineas = Linea.find(:all)
    @bancos = Banco.find(:all)
    @clientes = Cliente.find(:all)
    @promotores = Promotor.find(:all)
    @destinos = Destino.find(:all)
    @grupos = Grupo.find(:all)
  end

  def new_individual
    @credito = Credito.new
    @lineas = Linea.find(:all)
    @bancos = Banco.find(:all)
    @clientes = Cliente.find(:all)
    @promotores = Promotor.find(:all)
    @destinos = Destino.find(:all)
  end

  def create
    @credito = Credito.new(params[:credito])
    if @credito.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @credito = Credito.find(params[:id])
  end

  def update
    @credito = Credito.find(params[:id])
    if @credito.update_attributes(params[:credito])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @credito
    else
      render :action => 'edit'
    end
  end

  def destroy
    Credito.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
