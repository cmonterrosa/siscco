class ViviendasController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @vivienda_pages, @viviendas = paginate :viviendas, :per_page => 10
     @viviendas = Vivienda.find(:all, :order => 'tipo_vivienda')
  end

  def show
    @vivienda = Vivienda.find(params[:id])
  end

  def new
    @vivienda = Vivienda.new
  end

  def create
    inserta_registro(Vivienda.new(params[:vivienda]), 'Registro creado satisfactoriamente')
  end

  def edit
    @vivienda = Vivienda.find(params[:id])
  end

  def update
    actualiza_registro(Vivienda.find(params[:id]), params[:vivienda])
  end

  def destroy
    Vivienda.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
                    #-- Ajax --
  def live_search
      @viviendas = Vivienda.find(:all, :conditions => ["tipo_vivienda like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrovivienda', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --
end
