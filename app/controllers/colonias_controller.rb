class ColoniasController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @colonias = Colonia.find(:all, :order => 'colonia')
#    @colonia_pages, @colonias = paginate :colonias, :per_page => 10
  end

  def show
    @colonia = Colonia.find(params[:id])
  end

  def new
    @colonia = Colonia.new
  end

  def create
    inserta_registro(Colonia.new(params[:colonia]), 'Registro creado satisfactoriamente')
#    @colonia = Colonia.new(params[:colonia])
#    if @colonia.save
#      flash[:notice] = 'Registro creado satisfactoriamente.'
#      redirect_to :action => 'list'
#    else
#      render :action => 'new'
#    end
  end

  def edit
    @colonia = Colonia.find(params[:id])
  end

  def update
    actualiza_registro(Colonia.fin(params[:id]), params[:colonia])
#    @colonia = Colonia.find(params[:id])
#    if @colonia.update_attributes(params[:colonia])
#      flash[:notice] = 'Registro actualizado.'
#      redirect_to :action => 'show', :id => @colonia
#    else
#      render :action => 'edit'
#    end
  end

  def destroy
    Colonia.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

    #--- Funciones ajax para filtrado --
  def live_search
#      @banco_pages, @bancos = paginate :bancos, :per_page => 10
      @colonias = Colonia.find(:all, :order => 'colonia')
      @colonias = Colonia.find(:all, :conditions => ["colonia like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrocolonia', :layout => false) if request.xhr?
  end

end
