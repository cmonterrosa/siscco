
include LoginSystem
class BancosController < ApplicationController

before_filter :login_required

#require_role "capturistas"
#require_role ["gerentes","administradores"],  :for => [:destroy, :edit, :new]

def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @bancos = Banco.find(:all, :order => 'nombre')
  end

  def show
    @banco = Banco.find(params[:id])
  end

  def new
    @banco = Banco.new
  end

  def create
   inserta_registro(Banco.new(params[:banco]), 'Registro creado satisfactoriamente.')
  end

  def edit
    @banco = Banco.find(params[:id])
  end

  def update
    actualiza_registro_log(Banco.find(params[:id]), params[:banco])
  end

  def destroy
    Banco.find(params[:id]).destroy
    redirect_to :action => "list" 
  end

  #--- Funciones ajax para filtrado --
  def live_search
      @bancos = Banco.find(:all, :order => 'nombre')
      @bancos = Banco.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtronombre', :layout => false) if request.xhr?
  end

end
