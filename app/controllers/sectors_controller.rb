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
    @sector = Sector.new(params[:sector])
    if @sector.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sector = Sector.find(params[:id])
  end

  def update
    @sector = Sector.find(params[:id])
    if @sector.update_attributes(params[:sector])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @sector
    else
      render :action => 'edit'
    end
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
