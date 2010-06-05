class NegociosController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @negocio_pages, @negocios = paginate :negocios, :per_page => 10
     @negocios = Negocio.find(:all, :order => 'nombre')
  end

  def show
    @negocio = Negocio.find(params[:id])
  end

  def new
    @negocio = Negocio.new
#    @negocio.cliente_id = params[:cliente][:id]
#    @cliente =  Cliente.new(params[:cliente]) if params[:cliente]
    @giros = Giro.find(:all, :order => 'giro')
  end

  def create
    @cliente = Cliente.new(params[:cliente])
    @negocio = Negocio.new(params[:negocio])
    @negocio.cliente = @cliente
   if @cliente.save and @negocio.save
      flash[:notice] = 'Registro creado satisfactoriamente'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @negocio = Negocio.find(params[:id])
    @giros = Giro.find(:all, :order => 'giro')
  end

  def update
    @negocio = Negocio.find(params[:id])
#    @cliente = Cliente.find(:first, :conditions => ["id = ?", params[:cliente_id]])
    if @negocio.update_attributes(params[:negocio])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :controller => 'clientes', :id => @negocio.cliente
    else
      render :action => 'edit'
    end
  end

  def destroy
    Negocio.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

    #--- Funciones ajax para filtrado --
  def live_search
#      @banco_pages, @bancos = paginate :bancos, :per_page => 10
      @negocios = Negocio.find(:all, :order => 'nombre')
      @negocios = Negocio.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtronegocio', :layout => false) if request.xhr?
  end
end
