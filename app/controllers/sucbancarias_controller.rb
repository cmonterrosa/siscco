class SucbancariasController < ApplicationController
   before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @sucbancarias = Sucbancaria.find(:all, :order => 'nombre')
  end

  def show
    @sucbancaria = Sucbancaria.find(params[:id])
  end

  def new
    @sucbancaria = Sucbancaria.new
  end

  def create
    inserta_registro(Sucbancaria.new(params[:sucbancaria]), 'Registro creado satisfactoriamente')
  end

  def edit
    @sucbancaria = Sucbancaria.find(params[:id])
  end

  def update
    actualiza_registro(Sucbancaria.find(params[:id]), params[:sucbancaria])
  end

  def destroy
    Sucbancaria.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def live_search
      @sucbancarias = Sucbancaria.find(:all, :conditions => ["nombre like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrosucbancaria', :layout => false) if request.xhr?
  end
end
