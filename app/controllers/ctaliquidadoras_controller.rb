class CtaliquidadorasController < ApplicationController
before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @ctaliquidadoras = Ctaliquidadora.find(:all, :order => 'num_cta')
  end

  def show
    @ctaliquidadora = Ctaliquidadora.find(params[:id])
  end

  def new
    @ctaliquidadora = Ctaliquidadora.new
    @sucbancarias = Sucbancaria.find(:all)
  end

  def create
    inserta_registro(Ctaliquidadora.new(params[:ctaliquidadora]), 'Registro creado satisfactoriamente')
  end

  def edit
    @ctaliquidadora = Ctaliquidadora.find(params[:id])
    @sucbancarias = Sucbancaria.find(:all)
  end

  def update
    actualiza_registro(Ctaliquidadora.find(params[:id]), params[:ctaliquidadora])
  end

  def destroy
    Ctaliquidadora.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def live_search
      @ctaliquidadoras = Ctaliquidadora.find(:all, :conditions => ["num_cta like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtroctaliquidadora', :layout => false) if request.xhr?
  end
end
