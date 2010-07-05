class GirosController < ApplicationController
   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @giro_pages, @giros = paginate :giros, :per_page => 10
     @giros = Giro.find(:all, :order => 'giro')
  end

  def show
    @giro = Giro.find(params[:id])
  end

  def new
    @giro = Giro.new
  end

  def create
    inserta_registro(Periodo.new(params[:periodo]), 'Registro creado satisfactoriamente')
  end

  def edit
    @giro = Giro.find(params[:id])
  end

  def update
    actualiza_registro(Periodo.find(params[:id]), params[:periodo])
  end

  def destroy
    Giro.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
          #-- Ajax --
    def live_search
      @giros = Giro.find(:all, :conditions => ["giro like ?", "%#{params[:searchtext]}%"])
      return render(:partial => 'filtrogiro', :layout => false) if request.xhr?
   end
      #--- Funciones ajax para filtrado --
end
