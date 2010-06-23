class LineasController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @linea_pages, @lineas = paginate :lineas, :per_page => 10
     @lineas = Linea.find(:all, :order => 'cuenta_cheques')
  end

  def show
    @linea = Linea.find(params[:id])
  end

  def new
    @linea = Linea.new
    # ---- carga combos -----
    @fondeos = Fondeo.find(:all, :order => 'fuente')
    @status = Statu.find(:all, :order => 'statu')
  end

  def create
    @linea = Linea.new(params[:linea])
    if @linea.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @linea = Linea.find(params[:id])
  end

  def update
    @linea = Linea.find(params[:id])
    if @linea.update_attributes(params[:linea])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @linea
    else
      render :action => 'edit'
    end
  end

  def destroy
    Linea.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
              #-- Ajax --
  def live_search
          @lineas = Linea.find(:all, :conditions => "cuenta_cheques like '%#{params[:searchtext]}%'")
#      @lineas = Linea.find(:all, :conditions => "linea_autorizada like '%#{params[:searchtext]}%' or
#                                                 linea_disponible like '%#{params[:searchtext]}%'")
      return render(:partial => 'filtrolinea', :layout => false) if request.xhr?
  end
      #--- Funciones ajax para filtrado --

  def estado_cuenta
    @linea = Linea.new
    @lineas = Linea.find(:all)
  end

  def consultar
    @linea= Linea.find(params[:linea][:cuenta_cheques])
    @disponible = linea_disponible(@linea)
  end

  #--- Funciones para transferencia ----
  def transferir_fondos
    
  end
  
  
  def transferir
    @transferencia = Transferencia.new(params[:transferencia])
    @transferencia.user = User.find(session['user'])
    if @transferencia.save!
          flash[:notice]="Transferencia realizada correctamente"
          redirect_to :action => "transferir_fondos"
    else
          flash[:notice]="No se pudo realizar la transferencia, revise los datos"
          redirect_to :action => "transferir_fondos"
    end
  end






end
