class BancosController < ApplicationController
  #before_filter :login_required
  require_role "administradores", :only => [:list, :new]
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #@banco_pages, @bancos = paginate :bancos , :per_page => 10
    @bancos = Banco.find(:all, :order => 'nombre', :conditions => "st != 0")
  end

  def show
    @banco = Banco.find(params[:id])
  end

  def new
    @banco = Banco.new
  end

  def create
   inserta_registro_log(Banco.new(params[:banco]), 'Registro creado satisfactoriamente.')

#    @banco = Banco.new(params[:banco])
#    if @banco.save
#      flash[:notice] = 'Registro creado satisfactoriamente.'
#      redirect_to :action => 'list'
#    else
#      render :action => 'new'
#    end
  end

  def edit
    @banco = Banco.find(params[:id])
  end

  def update
#    @banco = Banco.update(params[:id].keys, params[:id].values).reject { |p| p.errors.empty? }
    actualiza_registro_log(Banco.find(params[:id]), params[:banco])
#    @banco = Banco.find(params[:id])
#    if @banco.update_attributes(params[:banco])
#      flash[:notice] = 'Registro actuaizado.'
#      redirect_to :action => 'show', :id => @banco
#    else
#      render :action => 'edit'
#    end
  end

  def destroy
    #Banco.find(params[:id]).destroy
    #redirect_to :action => 'list'
    elimina_registro_log(Banco.find(params[:id]), session['user'].rol)
  end

  #--- Funciones ajax para filtrado --
  def live_search
#      @banco_pages, @bancos = paginate :bancos, :per_page => 10
      @bancos = Banco.find(:all, :order => 'nombre')
      @bancos = Banco.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtronombre', :layout => false) if request.xhr?
  end

end
