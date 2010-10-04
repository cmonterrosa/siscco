class PolizasController < ApplicationController
  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @polizas = Poliza.find(:all)
  end

  def show
    @poliza = Poliza.find(params[:id])
  end

  def new
    @poliza = Poliza.new
  end

  def create
    inserta_registro(Poliza.new(params[:Poliza]), 'Registro creado satisfactoriamente')
  end

  def edit
    render :controller => "home"
    @poliza = Poliza.find(params[:id])
  end

  def update
    actualiza_registro(Poliza.find(params[:id]), params[:Poliza])
  end

  def destroy
    Poliza.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
          #-- Ajax --
  def live_search
    @polizas = Poliza.find(:all, :conditions => [" iEjer like ?", "%#{params[:searchtext]}%"])
    return render(:partial => 'filtroPoliza', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --
end
