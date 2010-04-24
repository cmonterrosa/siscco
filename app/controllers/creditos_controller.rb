class CreditosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @credito_pages, @creditos = paginate :creditos, :per_page => 10
  end

  def show
    @credito = Credito.find(params[:id])
  end

  def new
    @credito = Credito.new
  end

  def create
    @credito = Credito.new(params[:credito])
    if @credito.save
      flash[:notice] = 'Credito was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @credito = Credito.find(params[:id])
  end

  def update
    @credito = Credito.find(params[:id])
    if @credito.update_attributes(params[:credito])
      flash[:notice] = 'Credito was successfully updated.'
      redirect_to :action => 'show', :id => @credito
    else
      render :action => 'edit'
    end
  end

  def destroy
    Credito.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


  def transaccion
    @credito = Credito.find(params[:id])
  end




  #--- Métodos ajax ---
    def live_search_num
      @credito_pages, @creditos = paginate :creditos, :per_page => 20
      @creditos = Credito.find(:all, :conditions => ["id like ?", "%#{params[:num_credito]}%"])
      return render(:partial => 'filtrados', :layout => false) if request.xhr?
    end

    def live_search_rfc
      @cliente = Cliente.find(:first, :conditions => ["rfc like ?", "%#{params[:rfc_credito]}%" ])
      @credito_pages, @creditos = paginate :creditos, :per_page => 20
      if @cliente.nil? || @cliente.creditos.empty?
         @creditos=[]
      else
         @creditos = @cliente.creditos
      end
     
      return render(:partial => 'filtrados', :layout => false) if request.xhr?
    end

end
