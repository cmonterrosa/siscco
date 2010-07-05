class ProductosController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @producto_pages, @productos = paginate :productos, :per_page => 10
     @productos = Producto.find(:all, :order => 'producto')
  end

  def show
    @producto = Producto.find(params[:id])
  end

  def new
    @producto = Producto.new
    # ------ llena combos ------
    @grupos = Grupo.find(:all)
    @periodos = Periodo.find(:all)
  end

  def create
    inserta_registro(Producto.new(params[:producto]), 'Registro creado satisfactoriamente')
  end

  def edit
    @producto = Producto.find(params[:id])
    @grupos = Grupo.find(:all)
    @periodos = Periodo.find(:all)
  end

  def update
    actualiza_registro(Producto.find(params[:id]), params[:producto])
  end

  def destroy
    Producto.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
                  #-- Ajax --
  def live_search
      @productos = Producto.find(:all, :conditions => ["producto like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtroproducto', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --
end
