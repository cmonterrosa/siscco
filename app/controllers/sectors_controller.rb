class SectorsController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @sector_pages, @sectors = paginate :sectors, :per_page => 10
     @sectors = Sector.find(:all, :order => 'sector')
  end

  def show
    @sector = Sector.find(params[:id])
  end

  def new
    @sector = Sector.new
  end

  def create
    inserta_registro(Sector.new(params[:sector]), 'Registro creado satisfactoriamente')
  end

  def edit
    @sector = Sector.find(params[:id])
  end

  def update
    actualiza_registro(Sector.find(params[:id]), params[:sector])
  end

  def destroy
    Sector.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  def live_search
      @sectors = Sector.find(:all, :conditions => ["sector like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrosector', :layout => false) if request.xhr?
  end
end
