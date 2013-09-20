class ListaNegrasController < ApplicationController
  before_filter :login_required
  
  # GET /lista_negras
  # GET /lista_negras.xml
  require_role "admin", :for => "destroy"

  def index
    @lista_negras = ListaNegra.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lista_negras }
    end
  end

  # GET /lista_negras/1
  # GET /lista_negras/1.xml
  def show
    @lista_negra = ListaNegra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lista_negra }
    end
  end

  # GET /lista_negras/new
  # GET /lista_negras/new.xml
  def new
    @lista_negra = ListaNegra.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lista_negra }
    end
  end

  # GET /lista_negras/1/edit
  def edit
    @lista_negra = ListaNegra.find(params[:id])
  end

  # POST /lista_negras
  # POST /lista_negras.xml
  def create
    @lista_negra = ListaNegra.new(params[:lista_negra])

    respond_to do |format|
      if @lista_negra.save
        format.html { redirect_to(@lista_negra, :notice => 'El registro fue agregado a la Lista Negra.') }
        format.xml  { render :xml => @lista_negra, :status => :created, :location => @lista_negra }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lista_negra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lista_negras/1
  # PUT /lista_negras/1.xml
  def update
    @lista_negra = ListaNegra.find(params[:id])

    respond_to do |format|
      if @lista_negra.update_attributes(params[:lista_negra])
        format.html { redirect_to(@lista_negra, :notice => 'El registro fue actualizado.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lista_negra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lista_negras/1
  # DELETE /lista_negras/1.xml
  def destroy
    @lista_negra = ListaNegra.find(params[:id])
    @lista_negra.destroy

    respond_to do |format|
      format.html { redirect_to(lista_negras_url) }
      format.xml  { head :ok }
    end
  end

  def live_search
      @lista_negra = ListaNegra.find(:all, :conditions => "nombre like '%#{params[:searchtext]}%' or
                                                           paterno like '%#{params[:searchtext]}%' or
                                                           materno like '%#{params[:searchtext]}%'")
      return render(:partial => 'filtrolista', :layout => false) if request.xhr?
  end

  def match
    @clientes = []
    @clientes_ln = ListaNegra.find(:all, :select =>"id, curp, nombre, paterno, materno")
    @clientes_ln.each do |ln|
      if(@cl = Cliente.find_by_curp(ln.curp))
        @clientes << @cl
      end
    end
    flash[:notice] = "No existen Clientes en Lista Negra" if @clientes.empty?
  end
end