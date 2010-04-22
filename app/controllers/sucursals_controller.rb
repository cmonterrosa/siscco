class SucursalsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @sucursal_pages, @sucursals = paginate :sucursals, :per_page => 10
  end

  def show
    @sucursal = Sucursal.find(params[:id])
  end

  def new
    @sucursal = Sucursal.new
    #----- Consultas para actualizar dinamicamente los combos --
    @estados = Estado.find(:all, :order => "estado")
    @municipios = Municipio.find(:all, :order => "municipio")
    @ejidos = Ejido.find(:all, :order => "ejido")
     @colonias = Colonia.find(:all)
  end

  def create
    @sucursal = Sucursal.new(params[:sucursal])
    if @sucursal.save
      flash[:notice] = 'Sucursal was successfully created.'
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
      flash[:notice] = 'Sucursal was successfully updated.'
      redirect_to :action => 'show', :id => @sucursal
    else
      render :action => 'edit'
    end
  end

  def destroy
    Sucursal.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

   #--- Estas funciones son para manipular el AJAX

  def get_municipios
      @municipios= Municipio.find(:all, :conditions => ["estado_id = ?",params[:lugar_estado_id] ])
      return render(:partial => 'municipios', :layout => false) if request.xhr?
  end


   def get_ejidos
      @ejidos= Ejido.find(:all, :conditions => ["municipio_id = ?",params[:lugar_municipio_id] ])
      return render(:partial => 'ejidos', :layout => false) if request.xhr?
  end

    def get_colonias
      @colonias= Colonia.find(:all, :conditions => ["ejido_id = ?",params[:lugar_ejido_id] ])
      return render(:partial => 'colonias', :layout => false) if request.xhr?
    end


end
