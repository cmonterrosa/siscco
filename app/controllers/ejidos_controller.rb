class EjidosController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @ejido_pages, @ejidos = paginate :ejidos, :per_page => 10
     @ejidos = Ejido.find(:all, :order => 'ejido')
  end

  def show
    @ejido = Ejido.find(params[:id])
  end

  def new
    @ejido = Ejido.new
    #----- Consultas para actualizar dinamicamente los combos --
    @estados = Estado.find(:all, :order => "estado")
    @municipios = Municipio.find(:all, :order => "municipio")
  end

  def create
    @ejido = Ejido.new(params[:ejido])
    if @ejido.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @ejido = Ejido.find(params[:id])
  end

  def update
    @ejido = Ejido.find(params[:id])
    if @ejido.update_attributes(params[:ejido])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @ejido
    else
      render :action => 'edit'
    end
  end

  def destroy
    Ejido.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
      #--- Funciones ajax para filtrado --
  def live_search
#      @banco_pages, @bancos = paginate :bancos, :per_page => 10
      @ejidos = Ejido.find(:all, :order => 'ejido')
      @ejidos = Ejido.find(:all, :conditions => ["ejido like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtroejido', :layout => false) if request.xhr?
  end

end
