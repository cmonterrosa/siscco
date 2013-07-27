class CreditosController < ApplicationController
  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @credito_pages, @creditos = paginate :creditos, :per_page => 10
    redirect_to :action => "movimiento_credito"
  end

  def vencimiento
    @credito = Credito.find(params[:id])
  end

  def show
    @credito = Credito.find(params[:id])
  end

  def show_depositos
    @credito = Credito.find(params[:id])
    @depositos_aplicados = Deposito.find(:all, :conditions=>["credito_id = ?", @credito.id])
  end

  def modificar_referencia
    @credito = Credito.find(params[:id])
  end

  def calendario_pagos
    @credito = Credito.find(params[:id])
  end
  
  #----- Este metodo aplica todos los movimientos ----
  def abonar_individual
    @credito = Credito.find(params[:credito])
    @num_pagos = Pago.count(:id, :conditions=>["credito_id = ? AND pagado = 1", @credito.id]).to_i
    if @num_pagos == @credito.num_pagos
      #---- Ya se liquido el credito ----
        flash[:notice] = "Su credito ha sido liquidado"
        redirect_to :action => "transaccion", :id=>@credito
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

  def abonar_grupal #--- pago modificado
       @credito = Credito.find(params[:credito])
       @cliente = Cliente.find(params[:cliente])
       @num_pagos = Pago.count(:id, :conditions=>["credito_id = ? AND pagado = 1", @credito.id]).to_i

       if @num_pagos == @credito.producto.num_pagos
       #---- Ya se liquido el credito ----
        flash[:notice] = "Su credito ha sido liquidado"
        redirect_to :action => "transaccion_grupal", :id=>@credito
       else

        if (params[:pago][:capital].to_f + params[:pago][:interes].to_f) < pago_minimo_informativo(@credito).to_f
           #--- Si Se intenta pagar menos el minimo
           flash[:notice] = "Su pago minimo es de #{pago_minimo_informativo(@credito)}"
           redirect_to :action => "transaccion_grupal", :id=>@credito

        else
        #---- Se aplican pagos ----
        @pago =  proximo_pago_grupal(@credito, @cliente.id)
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

  def new
      redirect_to :action => "new_grupal"
  end

  def new_individual
     #--- Variables
     @productos = Producto.find(:all, :order => "producto")
     @destinos = Destino.find(:all)
     @promotores = Promotor.find(:all, :order => "nombre")
     @fondeos = Fondeo.find(:all, :order => "fuente")
     @lineas = Linea.find(:all)
     @clientes = Cliente.find(:all, :order => "paterno, materno, nombre")
  end

  def under_construction
    flash[:notice] = "MODULO EN CONSTRUCCION"
    redirect_to :action => "new_individual"
  end


   def create_nuevo_algoritmo
    @credito = Credito.new(params[:credito])
    @credito.producto = @producto = Producto.find(params[:credito][:producto_id])
    @fecha_inicio = Date.strptime(@credito.fecha_inicio.to_s)
    @credito.tasa_interes = @producto.tasa_anualizada
    @credito.num_referencia = params[:credito][:num_referencia] if params[:credito][:num_referencia]
    @tipo = (params[:credito][:grupo_id].nil?) ? "INDIVIDUAL" : "GRUPAL"
    @credito.linea = Linea.find(:first, :conditions => ["cuenta_cheques = ?", "RECURSOS PROPIOS"]) if @tipo == "INDIVIDUAL"
    @credito.grupo = Grupo.find(params[:credito][:grupo_id]) if @tipo == "GRUPAL"
    @n_pagos = Producto.find(:first, :conditions => ["id = ?", params[:credito][:producto_id]])
    @credito.fecha_fin = ultimo_pago(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, @n_pagos.num_pagos, @producto.periodo)
    inserta_credito(@credito, @tipo)
    arreglo_pagos = calcula_pagos(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, @producto.num_pagos, @producto.periodo)
    flash[:notice] = (@credito.inserta_pagos(arreglo_pagos, @credito.tipo_interes, @tipo)) ? "Credito guardado correctamente" : "No se pudo guardar, verifique"
    if @credito.inserta_pagos(arreglo_pagos, @credito.tipo_interes, @tipo)
      flash[:notice]="El crédito #{@credito.id} ha sido capturado"
      redirect_to :action => 'menu', :controller => "reportes", :id => @credito
    else
       @credito.destroy
       flash[:notice] = "Crédito no guardado"
       redirect_to :controller => "home"
    end
  end



  def create
    @credito = Credito.new(params[:credito])
    @producto = Producto.find(params[:credito][:producto_id])
    @credito.producto = @producto
    @fecha_inicio = Date.strptime(@credito.fecha_inicio.to_s)
    @credito.tasa_interes = @producto.tasa_anualizada
    @credito.num_referencia = params[:credito][:num_referencia] if params[:credito][:num_referencia]
    @tipo = (params[:credito][:grupo_id].nil?) ? "INDIVIDUAL" : "GRUPAL"
    @credito.linea = Linea.find(:first, :conditions => ["cuenta_cheques = ?", "RECURSOS PROPIOS"]) if @tipo == "INDIVIDUAL"
    @credito.grupo = Grupo.find(params[:credito][:grupo_id]) if @tipo == "GRUPAL"
    @n_pagos = Producto.find(:first, :conditions => ["id = ?", params[:credito][:producto_id]])
    @credito.fecha_fin = ultimo_pago(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, @n_pagos.num_pagos, @producto.periodo)
    
    ################## VALIDACIONES ###############################
    #--- Validamos si la linea de fondeo tiene disponible ----
    if linea_disponible(Linea.find(params[:credito][:linea_id])).to_f >=  params[:credito][:monto].to_f || @tipo == "INDIVIDUAL"
          if inserta_credito(@credito, @tipo)
             inserta_miembros(params[:miembro], @credito) if params[:miembro] && @tipo == "GRUPAL"
                if params[:credito][:grupo_id].nil?
                #--- Es individual -----
                   inserta_pagos_individuales(@credito, calcula_pagos(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, @producto.num_pagos, @producto.periodo))
                else
                    
                    inserta_pagos_grupales_por_tipo(@credito, calcula_pagos(@fecha_inicio.year, @fecha_inicio.month, @fecha_inicio.day, @producto.num_pagos, @producto.periodo), @credito.tipo_interes)
                       #update_pagos_grupales(@credito) #--- Actualizamos la tabla pagosgrupals
                       unless Cuenta.find(:all).empty? #--- Si existe alguna cuenta
                          inserta_poliza(params[:credito][:monto], Cuenta.find(:first), "ABONO")
                       end
                       inserta_credito_extraordinario(@credito) if params[:credito][:tipo_aplicacion]=="EXTRAORDINARIO" #----------- Si el tipo de aplicacion es extraordinaria -------

                end
                calcula_devengo_intereses(@credito)
           
           flash[:notice]="El crédito #{@credito.id} ha sido capturado"
           redirect_to :action => 'menu', :controller => "reportes", :id => @credito
        
          else
                flash[:notice]="El crédito no pudo ser grabado, verifique que el grupo tenga al menos dos clientes asociados"
                redirect_to :action => 'list'
          end
    else
      flash[:notice] = "La linea no cuenta con fondos disponibles"
      redirect_to :action => "index", :controller => 'home'
    end
  end

  
  def create_individual

  end

  def create_grupal

  end

  def edit
    @credito = Credito.find(params[:id])
    @destinos = Destino.find(:all)
    @promotores = Promotor.find(:all, :order => "nombre")
    @fondeos = Fondeo.find(:all, :order => 'acronimo')
    @fondeo = Fondeo.find_by_sql("select fo.id, fo.acronimo from fondeos fo
                                   left join lineas li on li.fondeo_id = fo.id
                                   left join creditos cr on cr.linea_id = li.id
                                   where cr.id = #{@credito.id}")
    @lineas = Linea.find(:all)
    @productos = Producto.find(:all, :order => "producto")
    @grupos = todos_grupos_conclientes

    @clientes = Cliente.find_by_sql("select c.id, c.nombre, c.paterno, c.materno, jr.jerarquia from clientes c
                                     inner join clientes_grupos cg on cg.cliente_id = c.id
                                     inner join grupos gr on gr.id = cg.grupo_id
                                     inner join creditos cr on cr.grupo_id = gr.id
                                     left join miembros mr on mr.cliente_id = c.id
                                     left join jerarquias jr on mr.jerarquia_id = jr.id
                                     where cr.id = #{@credito.id}")
#     @cliente = Cliente.find_by_sql("select c.id, c.nombre, c.paterno, c.materno, jr.jerarquia from clientes c
#                                      inner join miembros mr on mr.cliente_id = c.id
#                                      inner join creditos cr on cr.id = mr.credito_id
#                                      inner join jerarquias jr on mr.jerarquia_id = jr.id
#                                      where cr.id = #{@credito.id}##")
    @s_fondeo = fselected(@fondeo)
    @s_presidente = selected(@clientes, 'presidente')
    @s_secretario = selected(@clientes, 'secretario')
    @s_tesorero = selected(@clientes, 'tesorero')
  end

  def update
    @credito = Credito.find(params[:id])
    if @credito.update_attributes(params[:credito])
      flash[:notice] = 'Credito actualizado correctamente'
      redirect_to :action => 'show', :id => @credito
    else
      render :action => 'edit'
    end
  end

  def destroy
    #---- Verificamos si el credito tiene pagos pendientes ----
    unless Pago.find(:all, :conditions => ["credito_id = ?", params[:id]]).empty?
        Credito.find(params[:id]).destroy
        redirect_to :action => 'list'
    else
      flash[:notice] = "no se puede eliminar"
      redirect_to :action => 'list'
    end
  
  end

  def transaccion
    @credito = Credito.find(params[:id])
    @fecha_inicio = Date.strptime(Credito.find(params[:id]).fecha_inicio.to_s)
    #@pago = proximo_pago(@credito)

  end

  def transaccion_grupal
    @credito = Credito.find(params[:id])
    @fecha_inicio = Date.strptime(Credito.find(params[:id]).fecha_inicio.to_s)
    @pago = proximo_pago(@credito)
  end

  #--- Métodos ajax ---
  def live_search_op
     case session['opcion']
        when 'NUM. CREDITO'
          @creditos = Credito.find(:all, :select => "id, fecha_inicio, num_referencia, identificador, status", :conditions => ["id like ?", "%#{params[:_opcionc]}%"])
          return render(:partial => 'filtrados', :layout => false) if request.xhr?
        when 'GRUPO'
          @creditos = Credito.find_by_sql("select creditos.* from creditos inner join grupos on grupos.id = creditos.grupo_id and grupos.nombre like '%#{params[:_opcionc]}%'")
          return render(:partial => 'filtrados', :layout => false) if request.xhr?
        when 'REFERENCIA'
          @creditos = Credito.find(:all, :conditions => ["num_referencia like ?", params[:_opcionc]])
          return render(:partial => 'filtrados', :layout => false) if request.xhr?
        when 'RFC'
          @creditos = Credito.find_by_sql("select * from creditos inner join clientes on clientes.id = creditos.cliente_id and clientes.rfc like '%#{params[:_opcionc]}%'")
          return render(:partial => 'filtrados', :layout => false) if request.xhr?

        when 'LINEA'
          @creditos = Credito.find(:all, :select => "c.*", :joins =>"c, lineas l", :conditions => ["l.cuenta_cheques = ? and c.linea_id = l.id", params[:_opcionc]])
          return render(:partial => 'filtrados', :layout => false) if request.xhr?

        when nil
          flash[:notice] = 'Seleccione alguna opción de Búsqueda...'
          return render(:partial => 'filtrados', :layout => false) if request.xhr?
     end
  end

  def opcionc
#    session['opcion'] = nil
    session['opcion'] = params[:_opcion]
  end

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

  def new_grupal
     @grupos = Grupo.find(:all, :conditions => ["id NOT IN (select g.id from grupos g, creditos c where g.id = c.grupo_id AND status=0)"], :select => "id, nombre, identificador", :order =>"nombre")
     #--- Variables
     @productos = Producto.find(:all, :order => "producto")
     @destinos = Destino.find(:all)
     @promotores = Promotor.find(:all, :order => "paterno, materno, nombre")
     @fondeos = Fondeo.find(:all, :order => "fuente")
     @lineas = Linea.find(:all)
     @clientes = Cliente.find(:all, :select => "id, paterno, materno, nombre", :order => "paterno, materno LIMIT 10")
  end

  def activacion
    @creditos = Credito.find(:all)
  end

  def activar
    @credito = Credito.find(params[:id])
    if @credito.activar
      flash[:notice] = "El crédito fue activado"
    else
      flash[:notice] = "El crédito no pudo activarse, verifique los datos"
    end
   render :action => "movimiento_credito", :credito => @credito
  end

  def p_aplicar
    #--- muestra los pendientes por aplicar---
    @pendientes = Deposito.find(:all, :select => "ref_alfa, importe, fecha_hora, autorizacion, credito_id", :conditions => "ST='NA'")
    @datafile = Datafile.find(params[:id]).id if params[:id]
  end

   def desactivar
    @credito = Credito.find(params[:id])
    if @credito.desactivar
      flash[:notice] = "El crédito fue desactivado"
    else
      flash[:notice] = "El crédito no pudo activarse, verifique los datos"
    end
   render :action => "movimiento_credito", :credito => @credito
  end

  def show_pagos_cliente
    @pagos = Pago.find(:all, :conditions => ["cliente_id = ? and credito_id = ?",params[:id], params[:credito]])
    @credito = Credito.find(params[:credito])
    @pago = proximo_pago(@credito)
    @cliente = Cliente.find(params[:id])
    render :layout => false
  end

  def show_devengos
    @devengos = Devengo.find(:all, :conditions => ["credito_id = ?",params[:id]])
  end


  #----- Aplica depositos normales cargador por layout ------
  def aplicar_depositos
    depositos =Hash.new{|k,v|k[v]}
    datafile = Datafile.find(params[:id]).id if params[:id]
    @aplicados = []
    @sumatoria = 0
    @referencias = Deposito.find(:all, :select => "id, credito_id, st",  :conditions => ["st = ?", "NA"], :group=> "credito_id")
    @referencias.each do |referencia|
      depositos["#{referencia.credito_id}"]  = Deposito.sum(:importe, :conditions => ["credito_id = ?", referencia.credito_id])
    end
    depositos.each{|k,v|
       v = Vencimiento.new(Credito.find(k))
       v.procesar
       if v.aplicar_depositos(depositos["#{k}"].to_f, datafile)
         @sumatoria+=1
         @aplicados << v.credito.id
       end
    }

    if @aplicados.empty? #--- Validamos si al menos hay un aplicado
       flash[:notice] = "Depositos aplicados"
       redirect_to :action => "p_aplicar", :controller => "creditos"
    else
        @transacciones_aplicadas = []
      @aplicados.each do |row|
          @transacciones_aplicadas << Transaccion.find(:all, :select => "t.*", :joins => "t, pagogrupals pg, creditos c",
                 :conditions => ["t.pagogrupal_id = pg.id AND pg.credito_id = c.id and c.id = ?", row])

      end
    end
  end

  #--- aplicacion de depositos con fecha valor -----
  def aplicar_depositos_fvalor
    depositos =Hash.new{|k,v|k[v]}
    datafile = Datafile.find(params[:id]).id if params[:id]
    @aplicados = []
    @sumatoria = 0
    if datafile #--- Si corresponde a un datafile en especial
       @referencias = Fechavalor.find(:all, :select => "id, credito_id, st",  :conditions => ["st = ? AND datafile_id = ?", "NA", datafile.id], :group=> "credito_id")
    else
       @referencias = Fechavalor.find(:all, :select => "id, credito_id, st",  :conditions => ["st = ?", "NA"], :group=> "credito_id")
    end
    @referencias.each do |referencia|
    if datafile #--- Si corresponde a un datafile en especial
      depositos["#{referencia.credito_id}"]  = Fechavalor.sum(:importe, :conditions => ["credito_id = ? AND datafile_id = ?", referencia.credito_id, datafile.id])
    else
      depositos["#{referencia.credito_id}"]  = Fechavalor.sum(:importe, :conditions => ["credito_id = ?", referencia.credito_id])
    end
    end
    depositos.each{|k,v|
       credito = Credito.find(k)
       fv = Fechavalor.find_by_credito_id(k).fecha
       v = Vencimiento.new(credito, fv, "fechavalor")
       v.procesar
       if v.aplicar_depositos(depositos["#{k}"].to_f, datafile, "fechavalor")
         @sumatoria+=1
         @aplicados << v.credito.id
       end
    }

    if @aplicados.empty? #--- Validamos si al menos hay un aplicado
       flash[:notice] = "Depositos aplicados"
       redirect_to :action => "fv_p_aplicar", :controller => "creditos"
    else
      @transacciones_aplicadas = []
      @aplicados.each do |row|
          @transacciones_aplicadas << Transaccion.find(:all, :select => "t.*", :joins => "t, pagogrupals pg, creditos c",
                 :conditions => ["t.datafile_id = ? AND t.pagogrupal_id = pg.id AND pg.credito_id = c.id and c.id = ?", datafile, row])
      end
    end
  end

  def fv_p_aplicar
    #--- muestra los pendientes por aplicar---
    @pendientes = Fechavalor.find(:all, :select => "ref_alfa, importe, fecha_hora, autorizacion, credito_id", :conditions => "ST='NA' and tipo != 'EXTRAORDINARIO'")
  end

  def fv_extras_aplicados
    #--- muestra los pendientes por aplicar---
    @pendientes = Fechavalor.find(:all, :select => "ref_alfa, importe, fecha_hora, autorizacion, credito_id", :conditions => "ST='A' and tipo = 'EXTRAORDINARIO'")
  end

  def pagar_ventanilla
    
  end

  def new_individual_under_construction
    
  end

end
