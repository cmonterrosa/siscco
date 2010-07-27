class SubsectorsController < ApplicationController
   before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @subsectors = Subsector.find(:all, :order => "subsector")
  end

  def show
    @subsector = Subsector.find(params[:id])
  end

  def new
    @subsector = Subsector.new    
  end

  def create
    inserta_registro(Subsector.new(params[:subsector]), 'Registro creado satisfactoriamente')
  end

  def edit
    @subsector = Subsector.find(params[:id])
  end

  def update
    actualiza_registro(Subsector.find(params[:id]), params[:subsector])
  end

  def destroy
    Subsector.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
                  #-- Ajax --
  def live_search
      @subsectors = Subsector.find(:all, :conditions => ["subsector like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrosubsector', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --
end
