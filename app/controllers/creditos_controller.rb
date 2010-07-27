class CreditosController < ApplicationController
  before_filter :permiso_requerido
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @credito_pages, @creditos = paginate :creditos, :per_page => 10
    render :action => 'menu'
  end

  def show
    @credito = Credito.find(params[:id])
  end


  def finalizar_credito
    
  end
  



  #----- Este metodo aplica todos los movimientos ----
  def abonar
    #params[:pago].delete(:descripcion)
    #@movimiento = Movimiento.new(params[:pago])
    #@movimiento.save
    @credito = Credito.find(params[:credito])
    @num_pagos = Pago.count(:id, :conditions=>["credito_id = ? AND pagado = 1", @credito.id]).to_i

    if @num_pagos == @credito.num_pagos
      #---- Ya se liquido el credito ----
        flash[:notice] = "Su credito ha sido liquidado"
        redirect_to :action => "transaccion_grupal", :id=>@credito
    else

        if (params[:pago][:capital].to_f + params[:pago][:interes].to_f) < pago_minimo(@credito).to_f
           #--- Si Se intenta pagar menos el minimo
           flash[:notice] = "Su pago minimo es de #{pago_minimo(@credito)}"
           redirect_to :action => "transaccion_grupal", :id=>@credito

        else
        #---- Se aplican pagos ----
        @pago = Pago.find(params[:pago_id])
        @fecha = Date.civil(params[:pago][:"fecha(1i)"].to_i,params[:pago][:"fecha(2i)"].to_i,params[:pago][:"fecha(3i)"].to_i)
        cargos?(@pago, @fecha)
        @pago.update_attributes(:pagado=>1,
                           :fecha=> @fecha,
                           :capital=> params[:pago][:capital],
                           :interes=> params[:pago][:interes],
                           :cliente_id => params[:pago][:cliente_id])

          flash[:notice] = "Su pago ha sido abonado"
          redirect_to :action => "transaccion_grupal", :id=>@credito
        end
     end
 end


  def abonar2 #--- pago modificado
       @credito = Credito.find(params[:credito])
    @num_pagos = Pago.count(:id, :conditions=>["credito_id = ? AND pagado = 1", @credito.id]).to_i

    if @num_pagos == @credito.num_pagos
      #---- Ya se liquido el credito ----
        flash[:notice] = "Su credito ha sido liquidado"
        redirect_to :action => "transaccion_grupal", :id=>@credito
    else

        if (params[:pago][:capital].to_f + params[:pago][:interes].to_f) < pago_minimo(@credito).to_f
           #--- Si Se intenta pagar menos el minimo
           flash[:notice] = "Su pago minimo es de #{pago_minimo(@credito)}"
           redirect_to :action => "transaccion_grupal", :id=>@credito

        else
        #---- Se aplican pagos ----
        @pago =  proximo_pago_grupal(@credito, Cliente.find(params[:pago][:cliente_id]))
        #@pago = Pago.find(:first, params[:pago_id])
        @fecha = Date.civil(params[:pago][:"fecha(1i)"].to_i,params[:pago][:"fecha(2i)"].to_i,params[:pago][:"fecha(3i)"].to_i)
        cargos?(@pago, @fecha)
        @pago.update_attributes(:pagado=>1,
                           :fecha=> @fecha,
                           :capital=> params[:pago][:capital],
                           :interes=> params[:pago][:interes]
                           )

          flash[:notice] = "Su pago ha sido abonado"
          redirect_to :action => "transaccion_grupal", :id=>@credito
        end
     end
 end

  def activacion

  end

  def new
    @credito = Credito.new
  end

  def create
    @credito = Credito.new(params[:credito])
    @fecha_inicio = Date.strptime(@credito.fecha_inicio.to_s)
    #@credito.tasa_interes = Producto.find(params[:producto_id]).tasa_interes

    @credito.tasa_interes = Configuracion.find(:first, :select=>"tasa_interes").tasa_interes
    @credito.interes_moratorio = Configuracion.find(:first, :select=>"interes_moratorio").interes_moratorio
    @credito.fecha_hora = Time.now
    @credito.user_id = session['user'].id
    #@credito.grupo = Grupo.find(1) if params[:credito][:grupo_id].nil?
    if params[:credito][:grupo_id].nil?
      @tipo = "INDIVIDUAL"
    else
      @tipo = "GRUPAL"
    end

    @credito.fecha_fin = ultimo_pago(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, params[:credito][:num_pagos], Periodo.find(params[:credito][:periodo_id]))
    #--- Validamos si la linea de fondeo tiene disponible ----
    if linea_disponible(Linea.find(params[:credito][:linea_id])).to_f >=  params[:credito][:monto].to_f
          if inserta_credito(@credito, @tipo)
          #--- Insertamos el registro de los pagos que debe de realizar -----
           #inserta_pagos(@credito, calcula_pagos(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, params[:credito][:num_pagos], Periodo.find(params[:credito][:periodo_id])))
               #---- Validamos si es individual o grupal ----
               inserta_miembros(params[:miembro], @credito)
                if params[:credito][:grupo_id].nil?
                #--- Es individual -----
                   inserta_pagos_individuales(@credito, calcula_pagos(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, params[:credito][:num_pagos], Periodo.find(params[:credito][:periodo_id])))
                else
                   inserta_pagos_grupales(@credito, calcula_pagos(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, params[:credito][:num_pagos], Periodo.find(params[:credito][:periodo_id])))
                end
           
           flash[:notice]="El crédito #{@credito.id} ha sido capturado"
           redirect_to :action => 'list'
        
          else
                flash[:notice]="El crédito no pudo ser grabado, verifique que el grupo tenga clientes asociados"
                redirect_to :action => 'list'
          end
    else
      flash[:notice] = "La linea no cuenta con fondos disponibles"
      redirect_to :action => "index", :controller => 'home'
    end
  end

  def edit
    @credito = Credito.find(params[:id])
  end

  def update
    @credito = Credito.find(params[:id])
    @credito.fecha_hora = Time.now
    @credito.user_id = session['user'].id
    if @credito.update_attributes(params[:credito])
      flash[:notice] = 'Credito actualizado correctamente'
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
    @fecha_inicio = Date.strptime(Credito.find(params[:id]).fecha_inicio.to_s)
    @pago = proximo_pago(@credito)

  end

  def transaccion_grupal
    @credito = Credito.find(params[:id])
    @fecha_inicio = Date.strptime(Credito.find(params[:id]).fecha_inicio.to_s)
    #@pago = Pago.new
    @pago = proximo_pago(@credito)
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

    def nuevo_abono
      render :text => params[:id]
    end


  def inserta_miembros(miembros , credito)

    miembros.each do |miembro, cliente|
      @miembro = Miembro.new
      @jerarquia = Jerarquia.find(:first, :conditions => ["jerarquia = ?", miembro])
      @miembro.credito = credito
      @miembro.cliente_id = cliente.to_i
      @miembro.jerarquia = @jerarquia
      @miembro.save!
    end
  end

end
