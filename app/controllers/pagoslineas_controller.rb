class PagoslineasController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @pagoslinea_pages, @pagoslineas = paginate :pagoslineas, :per_page => 10
  end

  def show
    @pagoslinea = Pagoslinea.find(params[:id])
  end

  def new
    @pagoslinea = Pagoslinea.new
    @fondeos = Fondeo.find(:all, :order =>"fuente")
    @lineas = Linea.find(:all)
  end

  def create
    inserta_registro(Pagoslinea.new(params[:pagoslinea]), 'Registro creado satisfactoriamente')
  end

  def edit
    @pagoslinea = Pagoslinea.find(params[:id])
    @fondeos = Fondeo.find(:all, :order =>"fuente")
    @lineas = Linea.find(:all)
  end

  def update
    actualiza_registro(Pagoslinea.find(params[:id]), params[:pagoslinea])
  end

  def destroy
#    Pagoslinea.find(params[:id]).destroy
#    redirect_to :action => 'list'
    begin
      registro = Pagoslinea.find(:first, :conditions => ["id = ?", params[:id]])
      registro.destroy
    rescue ActiveRecord::StatementInvalid => error
        flash[:notice] = "No se puede eliminar el registro #{registro.nombre}, existen relaciones con otras tablas"
    end
    redirect_to :action => "list"
  end
end
