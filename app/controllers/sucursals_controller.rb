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
    @sucursal = Sucursal.new(params[:sucursal])
    if @sucursal.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sucursal = Sucursal.find(params[:id])
  end

  def update
    @sucursal = Sucursal.find(params[:id])
    if @sucursal.update_attributes(params[:sucursal])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @sucursal
    else
      render :action => 'edit'
    end
  end

  def destroy
    Sucursal.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def live_search
      @sucursals = Sucursal.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrosucursal', :layout => false) if request.xhr?
  end

end
