class NegociosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @negocio_pages, @negocios = paginate :negocios, :per_page => 10
  end

  def show
    @negocio = Negocio.find(params[:id])
  end

  def new
    @negocio = Negocio.new
    @giros = Giro.find(:all, :order => 'giro')
  end

  def create
    @cliente = Cliente.new(params[:cliente])
    @negocio = Negocio.new(params[:negocio])
   if @cliente.save and @negocio.save
      flash[:notice] = 'Cliente was successfully created.-----'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @negocio = Negocio.find(params[:id])
    @giros = Giro.find(:all, :order => 'giro')
  end

  def update
    @negocio = Negocio.find(params[:id])
    if @negocio.update_attributes(params[:negocio])
      flash[:notice] = 'Negocio was successfully updated.'
      redirect_to :action => 'show', :id => @negocio
    else
      render :action => 'edit'
    end
  end

  def destroy
    Negocio.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
