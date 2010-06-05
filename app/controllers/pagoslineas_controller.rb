class PagoslineasController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @pagoslinea_pages, @pagoslineas = paginate :pagoslineas, :per_page => 10
  end

  def show
    @pagoslinea = Pagoslinea.find(params[:id])
  end

  def new
    @pagoslinea = Pagoslinea.new
  end

  def create
    @pagoslinea = Pagoslinea.new(params[:pagoslinea])
    if @pagoslinea.save
      flash[:notice] = 'Pagoslinea was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @pagoslinea = Pagoslinea.find(params[:id])
  end

  def update
    @pagoslinea = Pagoslinea.find(params[:id])
    if @pagoslinea.update_attributes(params[:pagoslinea])
      flash[:notice] = 'Pagoslinea was successfully updated.'
      redirect_to :action => 'show', :id => @pagoslinea
    else
      render :action => 'edit'
    end
  end

  def destroy
    Pagoslinea.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
