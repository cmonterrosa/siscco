class EjidosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @ejido_pages, @ejidos = paginate :ejidos, :per_page => 10
  end

  def show
    @ejido = Ejido.find(params[:id])
  end

  def new
    @ejido = Ejido.new
  end

  def create
    @ejido = Ejido.new(params[:ejido])
    if @ejido.save
      flash[:notice] = 'Ejido was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @ejido = Ejido.find(params[:id])
  end

  def update
    @ejido = Ejido.find(params[:id])
    if @ejido.update_attributes(params[:ejido])
      flash[:notice] = 'Ejido was successfully updated.'
      redirect_to :action => 'show', :id => @ejido
    else
      render :action => 'edit'
    end
  end

  def destroy
    Ejido.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
