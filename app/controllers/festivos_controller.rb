class FestivosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @festivo_pages, @festivos = paginate :festivos, :per_page => 10
  end

  def show
    @festivo = Festivo.find(params[:id])
  end

  def new
    @festivo = Festivo.new
  end

  def create
    @festivo = Festivo.new(params[:festivo])
    if @festivo.save
      flash[:notice] = 'Festivo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @festivo = Festivo.find(params[:id])
  end

  def update
    @festivo = Festivo.find(params[:id])
    if @festivo.update_attributes(params[:festivo])
      flash[:notice] = 'Festivo was successfully updated.'
      redirect_to :action => 'show', :id => @festivo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Festivo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
