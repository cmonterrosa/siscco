class AvalsController < ApplicationController
     before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @aval_pages, @avals = paginate :avals, :per_page => 10
  end

  def show
    @aval = Aval.find(params[:id])
  end

  def new
    @aval = Aval.new
  end

  def create
    @aval = Aval.new(params[:aval])
    if @aval.save
      flash[:notice] = 'Aval was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @aval = Aval.find(params[:id])
  end

  def update
    @aval = Aval.find(params[:id])
    if @aval.update_attributes(params[:aval])
      flash[:notice] = 'Aval was successfully updated.'
      redirect_to :action => 'show', :id => @aval
    else
      render :action => 'edit'
    end
  end

  def destroy
    Aval.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
