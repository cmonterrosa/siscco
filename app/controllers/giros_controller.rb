class GirosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @giro_pages, @giros = paginate :giros, :per_page => 10
  end

  def show
    @giro = Giro.find(params[:id])
  end

  def new
    @giro = Giro.new
#    ------ carga combo subsectores -----
  end

  def create
    @giro = Giro.new(params[:giro])
    if @giro.save
      flash[:notice] = 'Registro creado satisfactoriamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @giro = Giro.find(params[:id])
  end

  def update
    @giro = Giro.find(params[:id])
    if @giro.update_attributes(params[:giro])
      flash[:notice] = 'Registro actualizado.'
      redirect_to :action => 'show', :id => @giro
    else
      render :action => 'edit'
    end
  end

  def destroy
    Giro.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
