

module Databases
  #---- Validaciones para realizar operaciones con la BD ------
   #--- Verificamos que el usuario tenga acceso a eliminar registro -----
      def inserta_credito(credito, tipo)
        begin
        @c_concentradora = Linea.find(credito.linea).ctaliquidadora 
        return false unless @c_concentradora
        #----- Creamos el numero de referencia automaticamente --------
          credito.num_referencia = genera_referencia_alfa(@c_concentradora.sucbancaria.num_sucursal, @c_concentradora.num_cta) unless credito.num_referencia
           if tipo == "GRUPAL"
             if credito.grupo.clientes.size >= 1 #-- aqui deberiamos de validar que sean 3
                 credito.monto_inicial = credito.monto unless credito.monto_inicial
                 if credito.save!
                    # asignamos la tasa moratoria
                    credito.update_attributes!(:interes_moratorio => credito.tasa_moratoria)
                    #--- Guardamos el log ---
                    Log.create(:operacion => "INSERTAR",
                    :clase => credito.class.to_s,
                    :objeto_id => credito.id.to_i,
                    :user_id => session['user'].id)
                    return true
                 else
                   return false
                 end
                 
             else
               return false
             end
          else
            #--- Es individual ----
            if credito.save!
               Log.create(:operacion => "INSERTAR",
                    :clase => credito.class.to_s,
                    :objeto_id => credito.id.to_i,
                    :user_id => session['user'].id)
              return true
            end
        end
      rescue ActiveRecord::RecordInvalid => invalid
          return false
        end
      end

#--- Funciones de insercion de registros ------

  def inserta_registro(registro, mensaje)
    begin
      registro.save!
        flash[:notice]=mensaje
        redirect_to :action => 'list', :controller => "#{params[:controller]}"
    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      redirect_to :action => 'new', :controller => "#{params[:controller]}"
    end
  end


  #----- esta funcion inserta y guarda un log por cada operacion -----
    def inserta_registro_log(registro, mensaje)
    begin
      if registro.save!
        #--- Guardamos el log ---
        Log.create(:operacion => "INSERTAR",
                   :clase => registro.class.to_s,
                   :objeto_id => registro.id.to_i,
                   :user_id => session['user'].id)
      end
        flash[:notice]=mensaje
        redirect_to :action => 'list', :controller => "#{params[:controller]}"
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:notice] = invalid
        redirect_to :action => 'new', :controller => "#{params[:controller]}"
      end
    end



  def inserta_cliente(cliente, negocio, mensaje)
    begin
      negocio.cliente = cliente

#      cliente.grupos << grupo
#      @log = Clientegrupo.new
#      @log.cliente= cliente
#      @log.grupo = grupo
#      @log.save!
        if cliente.save && negocio.save
          cliente.generar_id!
          flash[:notice]=mensaje + "con el identificador = #{cliente.identificador}"
          redirect_to :action => 'list', :controller => "#{params[:controller]}"
        else
           flash[:notice]= "Alguno de los campos no esta formado correctamente, verifica rfc y curp"
           render :action => 'new', :controller => "#{params[:controller]}"
        end

    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      redirect_to :action => 'new', :controller => "#{params[:controller]}"
    end
  end

  #------ Funciones de actualizacion de registros ------


  def actualiza_registro(registro, parametros)
    begin
      #registro.fecha_hora = Time.now
      #registro.user_id = session['user'].id
      registro.update_attributes(parametros)
      flash[:notice] = 'Registro actualizado satisfactoriamente'
      redirect_to :controller => params[:controller], :action => 'show', :id => registro
    rescue
      flash[:notice] = 'No se pudo actualizar verifique los datos'
      redirect_to :action => 'edit', :controller => params[:controller], :id=> registro
    end
  end


    #----- esta funcion inserta y guarda un log por cada operacion -----
    def actualiza_registro_log(registro, parametros)
    begin
      if registro.update_attributes(parametros)
        #--- Guardamos el log ---
        Log.create(:operacion => "ACTUALIZAR",
                   :clase => registro.class.to_s,
                   :objeto_id => registro.id.to_i,
                   :user_id => session['user'].id)
      end
        flash[:notice]='Registro actualizado satisfactoriamente'
        redirect_to :controller => params[:controller], :action => 'show', :id => registro
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:notice] = invalid
        redirect_to :action => 'edit', :controller => params[:controller], :id=> registro
      end
    end




 def actualiza_cliente(cliente, parametros_cliente, negocio, parametros_negocio)
    begin
#      @grupo_viejo = Clientegrupo.find(:first, :conditions => ["cliente_id = ? and activo = 1",cliente.id])
      cliente.update_attributes!(parametros_cliente)
      #---- Comparamos si el registro qie se quiere actualizar difiere en el grupo ------
      negocio.update_attributes!(parametros_negocio)
      flash[:notice] = 'Registro actualizado satisfactoriamente'
      redirect_to :controller => params[:controller], :action => 'show', :id => cliente
    rescue
      flash[:notice] = 'No se pudo actualizar verifique los datos'
      redirect_to :action => 'edit', :controller => params[:controller], :id=> cliente
    end
  end

 


#---------- Funciones de eliminacion de registros------

  def eliminar_registro(registro, rol)
    #------Verifica que se pueda eliminar el registro -----
   #if Systable.find(:first, :conditions=>["rol_id = ? and eliminar=1 and controller=?", rol, params[:controller]])
      begin
        registro.destroy
        flash[:notice]="Registro eliminado"
        redirect_to :action => 'list', :controller => params[:controller]
      rescue
        flash[:notice]="No se pudo eliminar, puede que el registro tenga tablas asociadas"
        redirect_to :action => 'list', :controller => params[:controller]
      end
#    else
#     flash[:notice]="No tiene privilegios para eliminar el registro"
#     redirect_to :action => 'list', :controller => params[:controller]
#   end
 end

  def elimina_registro_log(registro, rol)
    begin
      @controller = Controller.find_by_controller(params[:controller])
      #if Systable.find(:first, :conditions=>["rol_id = ? and eliminar=1 and controller_id=?", rol, @controller.id])
        #--- Cambiamos el estatus ----
        registro.st = 0
        registro.save!
        #--- Guardamos el log ---
        Log.create(:operacion => "ELIMINAR",
                   :clase => registro.class.to_s,
                   :objeto_id => registro.id.to_i,
                   :user_id => session['user'].id)
        flash[:notice]="Registro eliminado"
        redirect_to :action => 'list', :controller => params[:controller]
#      else
#        flash[:notice]="No tiene privilegios para eliminar el registro"
#        redirect_to :action => 'list', :controller => params[:controller]
#      end

     rescue ActiveRecord::RecordInvalid => invalid
        flash[:notice] = invalid
        redirect_to :action => 'edit', :controller => params[:controller], :id=> registro
     end
    end


  def confronta(datafile)
      begin
        datafile = Datafile.find(datafile)
        nombre_archivo = datafile.nombre_archivo
        num_linea = 1
        num_insertados = 0
        #---- Limpiamos los archivos basura ----
        File.delete("#{RAILS_ROOT}/tmp/err_#{nombre_archivo}") if File.exists?("#{RAILS_ROOT}/tmp/err_#{nombre_archivo}")
        File.delete("#{RAILS_ROOT}/tmp/na_#{nombre_archivo}") if File.exists?("#{RAILS_ROOT}/tmp/na_#{nombre_archivo}")
        #---- Creamos el archivo para los na ---
        @no_aplicados = File.new("#{RAILS_ROOT}/tmp/noaplicados_#{nombre_archivo}", "w+")
        #---- Creamos el archivo para los errores ---
        @errores = File.new("#{RAILS_ROOT}/tmp/errores_#{nombre_archivo}", "w+")
        #-- Abrimos el archivo ---
        File.open("#{RAILS_ROOT}/public/tmp/#{nombre_archivo}").each do |linea|
#          if num_linea >= 6
              fecha, sucursal, autorizacion, codigo, subcodigo, ref_alfa, importe, coma = linea.split(",")
#              m, u = importe.split(",")
#              unless u.nil?
#                total = (m + u).to_f
#              else
#                total = m.to_f
#              end
              
              

              #--- Aqui vamos a hacer el match -----
              @credito = Credito.find(:first, :conditions => ["num_referencia = ?", ref_alfa])
              if @credito
                  
                  #--- Insertamos el registro correspondiente al pago ---
                  @deposito = Deposito.new(:credito_id => @credito.id, :datafile_id => datafile.id, :sucursal => sucursal, :autorizacion => autorizacion, :codigo => codigo, :subcodigo => subcodigo, :ref_num => fecha, :ref_alfa => ref_alfa, :importe => importe.to_f)
                  unless @deposito.save
                    @no_aplicados.puts(linea)
                  end
                    num_insertados+=1
                    num_linea+=1
                    #Aqui mandaremos a llamar la funcion que nos devuelve cuando debe el cliente



                    next
                  #-- Aplicar el pago en el siguiente Orden ----
                  #IVA POR COMISIONES COBRADAS
                  #COMISIONES COBRADAS
                  #IVA POR INTERESES MORATORIOS
                  #INTERESES MORATORIOS
                  #IVA POR INTERESES NORMALES
                  #INTERESES NORMALES
                  #CAPITAL
                  #--- Iniciamos variables ---
                  @iva_gastos_cobranza = @gastos_cobranza = @iva_moratorio = @moratorio = @interes = 0
                  #--- Identificamos cual es el ultimo pago ---
#                  @proximo_pago = proximo_pago(@credito)
                  #--- si llegamos a pagar el capital le pones la bandera de pagado ---
#                  @vencimiento = Vencimiento.new(@credito)
#                  @vencimiento.procesar
                  #---- Empezamos a calcular ---
#                  if total > round((@vencimiento.gastos_cobranza * (0.16))) #--- Iva comisiones(gastos de cobranza)
#                     @iva_gastos_cobranza = round((@vencimiento.gastos_cobranza * (0.16)))
#                     total-=@iva_gastos_cobranza
#                     if total > round((@vencimiento.gastos_cobranza * (0.84))) # ---- comisiones(gastos de cobranza)
#                        @gastos_cobranza = round((@vencimiento.gastos_cobranza * (0.84)))
#                        total-=@gastos_cobranza
#                        if total > round(@vencimiento.moratorio * (0.16)) #--- Iva moratorio
#                           #--- aun no metemos el registro
#
#
#                           num_linea+=1
#                           next
#                        end
#                     end
#                  end

               else
                #--- Lo insertamos en lo no procesados un archivo de texto ----
                      @no_aplicados.puts(linea)
                      num_linea+=1
                      next
               end
#           end
#           num_linea+=1
        end
        return true, num_insertados
      rescue Exception => e
        @errores.puts(e.message)
        return false, num_insertados
      end
    end

#----- Fecha valor ----
     def confronta_fecha_valor(archivo)
      begin
        num_linea = 1
        num_insertados = 0
        nombre_archivo = archivo.nombre_archivo
        #---- Limpiamos los archivos basura ----
        File.delete("#{RAILS_ROOT}/tmp/err_fecha_valor_#{nombre_archivo}") if File.exists?("#{RAILS_ROOT}/tmp/err_fecha_valor_#{nombre_archivo}")
        File.delete("#{RAILS_ROOT}/tmp/na_fecha_valor_#{nombre_archivo}") if File.exists?("#{RAILS_ROOT}/tmp/na_fecha_valor_#{nombre_archivo}")
        #--- Obtenemos el id del archivo cargado ---
        @datafile = archivo
        #---- Creamos el archivo para los na ---
        @no_aplicados = File.new("#{RAILS_ROOT}/tmp/na_fecha_valor_#{nombre_archivo}", "w+")
        #---- Creamos el archivo para los errores ---
        @errores = File.new("#{RAILS_ROOT}/tmp/err_fecha_valor_#{nombre_archivo}", "w+")
        #-- Abrimos el archivo ---
        File.open("#{RAILS_ROOT}/public/tmp/#{nombre_archivo}").each do |linea|
              fecha,sucursal,autorizacion,codigo,subcodigo,ref_alfa, importe = linea.split(",")
              #--- Aqui vamos a hacer el match -----
              @credito = Credito.find(:first, :conditions => ["num_referencia = ?", ref_alfa])
              if @credito
                  #--- Insertamos el registro correspondiente al pago ---

                  @deposito = Fechavalor.new(:fecha => fecha.to_date, :credito_id => @credito.id, :datafile_id => @datafile.id, :sucursal => sucursal, :autorizacion => autorizacion, :codigo => codigo, :subcodigo => subcodigo, :ref_alfa => ref_alfa, :importe => importe.to_f)
                  unless @deposito.save
                    @no_aplicados.puts(linea)
                  end
                    num_insertados+=1
                    num_linea+=1
                    next
              else
                #--- Lo insertamos en lo no procesados un archivo de texto ----
                      @no_aplicados.puts(linea)
                      num_linea+=1
                      next
               end
                      num_linea+=1
        end
        return true, num_insertados
      rescue Exception => e
        @errores.puts(e.message)
        return false, num_insertados
      end
    end


  #---- Fecha valor para extras ---
 def confronta_fecha_valor_extras(archivo)
  begin
    num_linea = 1
    num_insertados = 0
    extras = 0
    nombre_archivo = archivo.nombre_archivo
    #--- Obtenemos el id del archivo cargado ---
    @datafile = archivo
    #---- Creamos el archivo para los na ---
    @nombre_aleatorio = rand(2**256).to_s(36)[0..7]
    @nombre_aleatorio_errores = rand(2**256).to_s(36)[0..7]
    @no_aplicados = File.new("#{RAILS_ROOT}/tmp/#{@nombre_aleatorio}", "w+")
    @datafile.update_attributes(:archivo_na => @nombre_aleatorio, :archivo_errores => @nombre_aleatorio_errores)
    #---- Creamos el archivo para los errores ---
    @errores = File.new("#{RAILS_ROOT}/tmp/#{@nombre_aleatorio_errores}", "w+")
    @creditos_hash = Hash.new
    @contador_creditos_normales = 0
    @info_hash = Hash.new
    c=0

    #--- Primero verificamos si el cliente va a liquidar el credito -----
     File.open("#{RAILS_ROOT}/public/tmp/#{nombre_archivo}").each do |linea|
     fecha,sucursal,autorizacion,codigo,subcodigo,ref_alfa, importe = linea.split(",")
     c+=1
     @credito = Credito.find(:first, :conditions => ["num_referencia = ? and tipo_aplicacion = 'EXTRAORDINARIO'", ref_alfa])
     @credito_normal = Credito.find(:first, :conditions => ["num_referencia = ? and tipo_aplicacion = 'NORMAL'", ref_alfa])
          if @credito && @credito.grupo
            @creditos_hash["#{@credito.id}"] ||= 0
            @creditos_hash["#{@credito.id}"] += importe.to_f
            @info_hash["#{@credito.id}"] = {:sucursal => sucursal, :autorizacion => autorizacion, :codigo => codigo, :subcodigo => subcodigo, :ref_alfa => ref_alfa}
          else
            if @credito_normal
               @no_aplicados.puts("=> No aplicado, porfavor cambie el tipo de aplicacion a extraordinario | " + linea)
               @contador_creditos_normales+=1
            else
               @no_aplicados.puts("=> No se encontro credito o la información del credito con referencia #{ref_alfa} es inconsistente, vetifique |" + linea)
            end
           
          end
     end



     @creditos_hash.each do |credito, valor|
       @credito = Credito.find(credito)
       calculo = Vencimiento.new(@credito)
       calculo.procesar
       diferencia = valor - calculo.total_deuda
       if diferencia >= 0
              #---- alcanza para liquidar la deuda, por lo que aplicamos todo el pago del credito ----
              pagosgrupals = Pagogrupal.find(:all, :conditions => ["credito_id = ?", credito])
              pagosgrupalsindividuales = Pago.find(:all, :conditions => ["credito_id = ?", credito])
              pagosgrupals.each do |pago| pago.update_attributes!(:pagado => 1) end unless @credito.liquidado?
              pagosgrupalsindividuales.each do |pago| pago.update_attributes!(:pagado => 1) end unless @credito.liquidado?
              if Extraordinario.find(:first, :conditions=> ["credito_id = ?", credito]).nil?
                inserta_credito_extraordinario(@credito)
              end
              @extra = Extraordinario.find(:first, :conditions=> ["credito_id = ?", credito])
              @pagoextra = Pagoextraordinario.create(:fecha => Time.now, :cantidad =>valor.to_f, :extraordinario_id => @extra.id)
              #--- cambiamos el estatus del credito a pagado ---
              @credito.update_attributes!(:status => 1)
              #--- Insertamos un registro para el control interno de las transacciones ----
              @deposito = Fechavalor.create(:fecha => Time.now, :credito_id => credito, :datafile_id => @datafile.id, :sucursal => @info_hash["#{credito}"][:sucursal], :autorizacion => @info_hash["#{credito}"][:autorizacion], :codigo => @info_hash["#{credito}"][:codigo], :subcodigo => @info_hash["#{credito}"][:subcodigo], :ref_alfa => @info_hash["#{credito}"][:ref_alfa], :importe => valor, :st => "A", :tipo => "EXTRAORDINARIO" )
              liberar_credito_grupal(@credito) if @credito.liquidado?
              @credito.update_attributes!(:fecha_liquidacion => Time.now) if @credito.fecha_liquidacion.nil?
              #---- ya no debe el grupo, se abonara a saldo a favor ---
              Excedente.create(:monto => diferencia, :credito_id => @credito.id, :fecha_deposito => Time.now) if diferencia > 0
              a=20
       else
         #--- Se pagara parcialmente
         # Calculamos si todos sus pagos estan vencidos
         @extra = Extraordinario.find(:first, :conditions=> ["credito_id = ?", credito])
         total_capital = valor.to_f * @extra.proporcion_capital
         total_interes = valor.to_f * @extra.proporcion_interes
         pagos_grupales = Pagogrupal.find(:all, :conditions => ["credito_id = ? and pagado=0", credito], :order=> "num_pago")
         pagos_grupales.each do |pago|
              if total_capital >= pago.capital_minimo
                              if total_interes >= pago.interes_minimo
                                pago.update_attributes!(:pagado =>1)
                                total_capital-=pago.capital_minimo
                                total_interes-=pago.interes_minimo
                              else
                                total_capital-=pago.capital_minimo
                                pago.update_attributes!(:capital_minimo => 0, :interes_minimo => pago.interes_minimo-=total_interes, :principal_recuperado=> 0)
                                total_interes=0
                              end
              else
                            if total_interes >= pago.interes_minimo
                                total_interes-=pago.interes_minimo
                                pago.update_attributes!(:interes_minimo => 0, :capital_minimo => pago.capital_minimo-=total_capital, :principal_recuperado => pago.principal_recuperado-=total_capital)
                                total_capital=0
                            else
                                pago.update_attributes!(:capital_minimo => pago.capital_minimo-=total_capital)
                                pago.update_attributes!(:interes_minimo => pago.interes_minimo-=total_interes)
                                total_capital=0
                                total_interes=0
                            end
              end
                        # si es el ultimo pago y nos queda excedente
                        if pago.num_pago == Pagogrupal.maximum(:num_pago, :conditions => ["credito_id = ?", credito])
                            residuo = total_capital + total_interes
                            if pago.capital_minimo==0 #-- ya se liquido el capital
                                pago.update_attributes!(:interes_minimo => pago.interes_minimo-=residuo)
                            else
                                if pago.interes_minimo==0 #-- ya se liquido el interes
                                    pago.update_attributes!(:capital_minimo => pago.capital_minimo-=residuo,  :principal_recuperado=> pago.principal_recuperado-=residuo)
                                end
                            end
                        end
        end
        
        @credito = Credito.find(credito)
        @deposito = Fechavalor.create(:fecha => Time.now, :credito_id => credito, :datafile_id => @datafile.id, :sucursal => @info_hash["#{credito}"][:sucursal], :autorizacion => @info_hash["#{credito}"][:autorizacion], :codigo => @info_hash["#{credito}"][:codigo], :subcodigo => @info_hash["#{credito}"][:subcodigo], :ref_alfa => @info_hash["#{credito}"][:ref_alfa], :importe => valor, :st => "A", :tipo => "EXTRAORDINARIO" )
        Pagoextraordinario.create(:fecha => Time.now, :cantidad => valor.to_f, :extraordinario_id => @extra.id)
        a=10
      end
      
     end
    num_insertados = @creditos_hash.size
    return true, num_insertados, @nombre_aleatorio
  rescue Exception => e
    @errores.puts(e.message)
    #return false, num_insertados, @nombre_aleatorio
  end
end


 def inserta_credito_extraordinario(credito)
    if credito.tipo_interes == "SALDOS INSOLUTOS (SSI)"
       @tasa_normal_mensual = round((((credito.producto.tasa_anualizada.to_f) / 360.0 ) * 30), 4)
    else
       @tasa_normal_mensual = credito.producto.tasa_mensual_flat.to_f
    end
    meses = @credito.producto.num_pagos / @credito.producto.periodo.pagos_mes
    interes_total_vida_credito = @tasa_normal_mensual * meses
    total_interes= Pagogrupal.sum(:interes_minimo, :conditions => ["credito_id= ?", @credito.id])


    #total_interes = @credito.monto * (interes_total_vida_credito / 100.0)
    total_recuperar = 100 + interes_total_vida_credito
    @proporcion_capital = (100.0 / total_recuperar)
    @proporcion_interes = (interes_total_vida_credito / total_recuperar)
    Extraordinario.transaction do
       Extraordinario.create(:credito_id=> @credito.id, :capital => @credito.monto,
                             :interes => total_interes, :proporcion_capital => @proporcion_capital,
                             :proporcion_interes => @proporcion_interes)
    end

end


end
