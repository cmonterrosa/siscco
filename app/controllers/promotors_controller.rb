class PromotorsController < ApplicationController
  helper :send_doc
  include SendDocHelper


   before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
#    @promotor_pages, @promotors = paginate :promotors, :per_page => 10
     @promotors = Promotor.find(:all, :order => 'Paterno')
  end

  def show
    @promotor = Promotor.find(params[:id])
  end

  def new
    @promotor = Promotor.new
  end

  def create
    inserta_registro(Promotor.new(params[:promotor]), 'REgistro creado satisfactoriamente')
  end

  def edit
    @promotor = Promotor.find(params[:id])
  end

  def update
    actualiza_registro(Promotor.find(params[:id]), params[:promotor])
  end

  def destroy
    Promotor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
                   #-- Ajax --
  def live_search
      @promotors = Promotor.find(:all, :conditions => "nombre like '%#{params[:searchtext]}%' or
                                                       paterno like '%#{params[:searchtext]}%' or
                                                       materno like '%#{params[:searchtext]}%'")
      return render(:partial => 'filtropromotor', :layout => false) if request.xhr?
  end

  def xml
    render :xml => Promotor.find(:all).to_xml
  end

  def reporte
    @promotores=Promotor.find(:all).to_xml
   send_doc_xml(@promotores,
     '/promotors/promotor',
    'promotores',
    'Promotores',
    "",
    'pdf')
  end

      #--- Funciones ajax para filtrado --
end
