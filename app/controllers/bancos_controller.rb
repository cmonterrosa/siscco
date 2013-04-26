class BancosController < ApplicationController
 #before_filter :login_required
 require_role :admin





  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

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
    a=10
    inserta_registro(Banco.new(params[:banco]), 'Registro creado satisfactoriamente.')
  end

  def edit
    @banco = Banco.find(params[:id])
  end

  def update
    actualiza_registro_log(Banco.find(params[:id]), params[:banco])
  end

  def destroy
    begin
      registro = Banco.find(:first, :conditions => ["id = ?", params[:id]])
#      Banco.find(params[:id]).destroy
      registro.destroy
    rescue ActiveRecord::StatementInvalid => error
#      if error.to_s.include?("foreign key constraint fails")
        flash[:notice] = "No se puede eliminar el registro #{registro.nombre}, existen relaciones con otras tablas"
#      end
    end
    redirect_to :action => "list"
  end
  #--- Funciones ajax para filtrado --
  def live_search
      @bancos = Banco.find(:all, :order => 'nombre')
      @bancos = Banco.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtronombre', :layout => false) if request.xhr?
  end





end
