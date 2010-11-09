class CtaconcentradorasController < ApplicationController
before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @ctaconcentradoras = Ctaconcentradora.find(:all, :order => 'num_cta')
  end

  def show
    @ctaconcentradora = Ctaconcentradora.find(params[:id])
  end

  def new
    @ctaconcentradora = Ctaconcentradora.new
    @sucbancarias = Sucbancaria.find(:all)
  end

  def create
    inserta_registro(Ctaconcentradora.new(params[:ctaconcentradora]), 'Registro creado satisfactoriamente')
  end

  def edit
    @ctaconcentradora = Ctaconcentradora.find(params[:id])
    @sucbancarias = Sucbancaria.find(:all)
  end

  def update
    actualiza_registro(Ctaconcentradora.find(params[:id]), params[:ctaconcentradora])
  end

  def destroy
    Ctaconcentradora.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def live_search
      @ctaconcentradoras = Ctaconcentradora.find(:all, :conditions => ["num_cta like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtroctaconcentradora', :layout => false) if request.xhr?
  end
end
