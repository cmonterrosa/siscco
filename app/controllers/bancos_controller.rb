class BancosController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @bancos = Banco.find(:all, :order => 'nombre') #@banco_pages, @bancos = paginate :bancos , :per_page => 10
  end

  def show
    @banco = Banco.find(params[:id])
  end

  def new
    @banco = Banco.new
  end

  def create
    @banco = Banco.new(params[:banco])
    if @banco.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @banco = Banco.find(params[:id])
  end

  def update
    @banco = Banco.find(params[:id])
    if @banco.update_attributes(params[:banco])
      flash[:notice] = 'Registro actuaizado.'
      redirect_to :action => 'show', :id => @banco
    else
      render :action => 'edit'
    end
  end

  def destroy
    Banco.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  #--- Funciones ajax para filtrado --
  def live_search
#      @banco_pages, @bancos = paginate :bancos, :per_page => 10
      @bancos = Banco.find(:all, :order => 'nombre')
      @bancos = Banco.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtronombre', :layout => false) if request.xhr?
  end

end
