class InversionistasController < ApplicationController
     before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @inversionista_pages, @inversionistas = paginate :inversionistas, :per_page => 10
  end

  def show
    @inversionista = Inversionista.find(params[:id])
  end

  def new
    @inversionista = Inversionista.new
  end

  def create
    @inversionista = Inversionista.new(params[:inversionista])
    if @inversionista.save
      flash[:notice] = 'Inversionista was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @inversionista = Inversionista.find(params[:id])
  end

  def update
    @inversionista = Inversionista.find(params[:id])
    if @inversionista.update_attributes(params[:inversionista])
      flash[:notice] = 'Inversionista was successfully updated.'
      redirect_to :action => 'show', :id => @inversionista
    else
      render :action => 'edit'
    end
  end

  def destroy
    Inversionista.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
