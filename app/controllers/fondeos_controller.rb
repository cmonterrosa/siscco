class FondeosController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @fondeo_pages, @fondeos = paginate :fondeos, :per_page => 10
     @fondeos = Fondeo.find(:all, :order => 'fuente')
  end

 
  def show
    @fondeo = Fondeo.find(params[:id])
  end

  def new
    @fondeo = Fondeo.new
  end

  def create
    inserta_registro(Fondeo.new(params[:fondeo]), 'Registro creado satisfactoriamente')
  end

  def edit
    @fondeo = Fondeo.find(params[:id])
  end

  def update
    actaliza_registro(Fondeo.find(params[:id]), params[:fondeo])
  end

  def destroy
    eliminar_registro(Fondeo.find(params[:id]), session['user'].rol)
  end
      #-- Ajax --
    def live_search
#      @estado_pages, @estados = paginate :estado, :per_page => 10
      @fondeos = Fondeo.find(:all, :conditions => ["fuente like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrofondeo', :layout => false) if request.xhr?
   end
      #--- Funciones ajax para filtrado --
   


end
