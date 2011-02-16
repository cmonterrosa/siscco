###############################################
#            Funciones del crédito            #
###############################################


module Creditos
  def abonos(credito)
    @pagos = Pago.find(:all,
                       :conditions=>["credito_id = ? AND pagado= 1", credito.id])
    sum=0
    @pagos.each do |pago|
      sum +=  pago.capital.to_f
    end
    return sum
  end


  def dias_credito(credito)
    return DateTime.now.yday - credito.fecha_inicio.yday
  end

  def periodos_transcurridos(credito)
    return (dias_credito(credito).to_i / credito.producto.periodo.dias)
  end

  #---- DIas sin pagar ----

   def dias_sin_pagar(credito)
     pago_siguiente = Pago.find(:first, :conditions => ["pagado = 0 AND credito_id = ?", credito.id], :order =>"num_pago", :group => "cliente_id")
     hoy = DateTime.now.yday
     if DateTime.now.year > pago_siguiente.fecha_limite.year
        hoy+=365 * (DateTime.now.year - pago_siguiente.fecha_limite.year)
     end
     return (hoy - pago_siguiente.fecha_limite.yday).to_i
   end

   def periodos_sin_pagar(credito)
     dias = dias_sin_pagar(credito).to_i
     periodos = dias / (credito.producto.periodo.dias)
    #--- Verificamos si ya se pago cuando menos un dia --
    if (dias % (credito.producto.periodo.dias)) > 0
       periodos+=1
    end
    return periodos
   end

 def vencimiento_capital(credito)
   return periodos_transcurridos(credito) * pago_minimo_informativo(credito)
 end

 def total(credito)
    @total =  (credito.monto * (credito.tasa_interes / 100.0)) + credito.monto
    return @total - abonos(credito)
 end

  #--- Esta funcion la mandamos a llamar del reporte -----
  def pago_minimo_informativo(credito)
     pago = Pago.find(:first, :conditions => ["credito_id = ?", credito.id])
     return pago.capital_minimo.to_f + pago.interes_minimo.to_f
  end

  def total_adeudado_por_persona(credito)
    #--- dividimos el total entre el numero de personas -----
    @num_personas = credito.grupo.clientes.size
    @interes = Pago.sum(:interes_minimo, :conditions=>["credito_id = ?", credito.id]).to_f / @num_personas.to_f
    @capital = Pago.sum(:capital_minimo, :conditions=>["credito_id = ?", credito.id]).to_f / @num_personas.to_f
    return round(@interes + @capital)

  end

  def pago_minimo(credito)
        @producto = Producto.find(credito.producto_id)
          #--- Verificamos si el credito ha sido cubierto ----
       @proximo_pago= proximo_pago(credito)
       if Time.now.to_date <= @proximo_pago.fecha_limite
         return @proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f
       else
         return ((@proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f)*(@producto.interes_moratorio)) + @proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f
       end
  end



  #---- Funciones de calculos -----
  def calcula_capital_minimo(credito)
      @producto = Producto.find(credito.producto_id)
      #---- si es grupal -------
      if credito.grupo_id
        @miembros = Grupo.find(credito.grupo_id).clientes.size
        return (credito.monto.to_f / @miembros) / @producto.num_pagos.to_f
      else
      #----- si es individual -----
        return (credito.monto.to_f) / @producto.num_pagos.to_f
      end
  end

  def calcula_interes_minimo(credito)
    @producto = Producto.find(credito.producto_id)
    @tasa_interes = (( credito.tasa_interes / 100.0) / @producto.periodo.pagos_mes).to_f
    if credito.grupo_id
      @miembros = Grupo.find(credito.grupo_id).clientes.size
      return (credito.monto.to_f / @miembros)  * @tasa_interes
    else
      return (credito.monto.to_f)  * @tasa_interes
    end
  end





  def proximo_pago(credito)
          @proximo = Pago.find(:first, :conditions=>["credito_id = ? AND pagado=0", credito.id], :order=>"fecha_limite", :group => "cliente_id")
          return @proximo
  end


  

  def proximo_pago_grupal(credito, cliente)
           @proximo = Pago.find(:first, :conditions=>["credito_id = ? AND
                                                   pagado=0 AND cliente_id = ?", credito.id, cliente.id],
                                                   :order=>"fecha_limite")
          return @proximo
  end

  def ultimo_pago(anio, mes, dia, num_pagos, periodo)
        @dias = num_pagos.to_i * periodo.dias.to_i
           @f_ini = Date.new(y=anio.to_i,m=mes.to_i,d=dia.to_i)
           # --- Creamos un arreglo donde pondremos los pagos ---
           @pagos = []
           @fecha_preliminar = @f_ini
           (num_pagos.to_i).times{
           @fecha_preliminar = @fecha_preliminar + periodo.dias.to_i
           #---- Validamos si es inhabil o dia festivo -----
           if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) || @fecha_preliminar.wday == 0
              if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) && @fecha_preliminar.wday == 6
                 @fecha_preliminar += 2 #--- Es festivo y es sabado --
                 @pagos << @fecha_preliminar
              else
                 @fecha_preliminar += 1
                 @pagos << @fecha_preliminar
              end
           else
              @pagos << @fecha_preliminar
           end
           }
           return @pagos.last
  end

  def calcula_pagos(anio, mes, dia, num_pagos, periodo)
        @dias = num_pagos.to_i * periodo.dias.to_i
           @f_ini = Date.new(y=anio.to_i,m=mes.to_i,d=dia.to_i)
           # --- Creamos un arreglo donde pondremos los pagos ---
           @pagos = []
           @fecha_preliminar = @f_ini
           (num_pagos.to_i).times{
           @fecha_preliminar = @fecha_preliminar + periodo.dias.to_i
           #---- Validamos si es inhabil o dia festivo -----
           if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) || @fecha_preliminar.wday == 0
              if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) && @fecha_preliminar.wday == 6
                 @fecha_preliminar += 2 #--- Es festivo y es sabado --
                 @pagos << @fecha_preliminar
              else
                 @fecha_preliminar += 1
                 @pagos << @fecha_preliminar
              end
           else
              @pagos << @fecha_preliminar
           end
           }
           return @pagos
  end



  def inserta_pagos_individuales(credito, arreglo_pagos)
         if credito.pagos.size == 0
         contador=1
         #---- Esta funcion crea los registros en la tabla pagos para tener un historial ----
            arreglo_pagos.each do |x|
                   Pago.create(:num_pago => contador,
                             :credito_id => credito.id.to_i,
                             :cliente_id => credito.cliente_id,
                             :fecha_limite => x,
                             :capital_minimo => calcula_capital_minimo(credito),
                             :interes_minimo => calcula_interes_minimo(credito),
                             :pagado => 0,
                             :descripcion => "Pago #{contador} de #{arreglo_pagos.size} capital minimo #{calcula_capital_minimo(credito)} ")
                 contador+=1
            end
         else
           return nil
         end
    end


  def inserta_pagos_grupales(credito, arreglo_pagos)
       if credito.pagos.size == 0
         #--- Hacemos una iteracion por todos los miembros del grupo y dividimos el total del credito ---
         clientes_activos_grupo(Grupo.find(credito.grupo_id)).each do |y|
           contador=1
            arreglo_pagos.each do |x|
                   Pago.create(:num_pago => contador,
                             :credito_id => credito.id,
                             :fecha_limite => x,
                             :cliente_id => y.id.to_i,
                             :capital_minimo => calcula_capital_minimo(credito),
                             :interes_minimo => calcula_interes_minimo(credito),
                             :pagado => 0,
                             :descripcion => "Pago #{contador} de #{arreglo_pagos.size} capital minimo")
                 contador+=1
               end
            end
       else
           return nil
       end
    end


  def inserta_pagos_grupales_por_tipo(credito, arreglo_pagos, tipos_interes)
    @producto = Producto.find(credito.producto_id)
    @capital = (credito.monto.to_f / credito.grupo.clientes.size.to_f)
    @capital_semanal = @capital / @producto.num_pagos
    #@tasa_semanal =   ((@producto.intereses.to_f / 100.0 ) / 30.0) * 7
    @tasa_semanal = round((((@producto.tasa_anualizada.to_f) / 360.0 ) * 7) / 100.0, 4)
    case tipos_interes
      when "Pagos iguales con decremento de interes e incremento de capital"
        @pago_semanal = round((@capital * (@tasa_semanal/(1-(1 + @tasa_semanal)**(@producto.num_pagos*-1)))),2)
        #@pago_semanal =  Integer(@pago_semanal * 100) / Float(100)
        clientes_activos_grupo(Grupo.find(credito.grupo_id)).each do |y|
              contador=1
              saldo_inicial = @capital
              arreglo_pagos.each do |x|
                   @interes_minimo = round(saldo_inicial * @tasa_semanal, 2)
                   @principal_recuperado = @pago_semanal - @interes_minimo
                   Pago.create(:num_pago => contador,
                             :credito_id => credito.id,
                             :fecha_limite => x,
                             :cliente_id => y.id.to_i,
                             :capital_minimo => @principal_recuperado,
                             :principal_recuperado => @principal_recuperado,
                             :interes_minimo => @interes_minimo,
                             :saldo_inicial => saldo_inicial,
                             :saldo_final => (saldo_inicial - @principal_recuperado),
                             :pagado => 0,
                             :descripcion => tipos_interes)
                   contador+=1
                   saldo_inicial -= @principal_recuperado
               end
            end

      #---- Aqui vamos a calcular el devengo diario -------

      

         when "Pagos iguales de capital"
              #-- Hacemos los calculos correspondientes ----
              
              #--- Hacemos una iteracion por todos los miembros del grupo y dividimos el total del credito ---
              clientes_activos_grupo(Grupo.find(credito.grupo_id)).each do |y|
              contador=1
              saldo_inicial = @capital
              arreglo_pagos.each do |x|
                   Pago.create(:num_pago => contador,
                             :credito_id => credito.id,
                             :fecha_limite => x,
                             :cliente_id => y.id.to_i,
                             :capital_minimo => @capital_semanal,
                             :principal_recuperado => @capital_semanal,
                             :interes_minimo => saldo_inicial * @tasa_semanal,
                             :saldo_inicial => saldo_inicial,
                             :saldo_final => saldo_inicial - @capital_semanal,
                             :pagado => 0,
                             :descripcion => tipos_interes)
                   contador+=1
                   saldo_inicial -= @capital_semanal
               end
            end
      when "Pagos con tasa flat (calculo sobre el saldo global de credito)"
         @meses = @producto.num_pagos / 4
         @total_interes = @capital * (@producto.intereses.to_f / 100) * @meses
         @interes_semanal = @total_interes / @producto.num_pagos
              clientes_activos_grupo(Grupo.find(credito.grupo_id)).each do |y|
                contador=1
                saldo_inicial = @capital
                arreglo_pagos.each do |x|
                    Pago.create(:num_pago => contador,
                               :credito_id => credito.id,
                               :fecha_limite => x,
                               :cliente_id => y.id.to_i,
                               :capital_minimo => @capital_semanal,
                               :interes_minimo => @interes_semanal,
                               :principal_recuperado => @capital_semanal,
                               :saldo_inicial => saldo_inicial,
                              :saldo_final => saldo_inicial - @capital_semanal,
                              :pagado => 0,
                              :descripcion => tipos_interes)
                    contador+=1
                    saldo_inicial -= @capital_semanal
                end
             end
    end
  end




    def linea_disponible(linea)
    if linea.creditos.empty?
           return linea.autorizado.to_f + total_recibido(linea) - total_transferido(linea)
        else
           return (linea.autorizado.to_f - total_otorgado_creditos(linea) + total_recibido(linea) - total_transferido(linea))
        end
    end

    def total_otorgado_creditos(linea)
       if Credito.count(:monto, :conditions=>["linea_id = ?", linea.id]) > 0
           return Credito.sum(:monto, :conditions=>["linea_id = ?", linea.id])/1.0
          return @credito
       else
          return 0
       end
    end

    def total_transferido(linea)
        sum_otorgadas = 0
        @t_otorgadas = Transferencia.find(:all, :conditions => ["origen_id = ?", linea.id])
        @t_otorgadas.each{|otorgada| sum_otorgadas += otorgada.monto.to_f }
        return sum_otorgadas * 1.0
    end

    def total_recibido(linea)
      sum_recibidas=0
      @t_recibidas = Transferencia.find(:all, :conditions => ["destino_id = ?", linea.id])
      @t_recibidas.each{|recibida| sum_recibidas += recibida.monto.to_f }
      return sum_recibidas * 1.0
    end

   
        def cargos?(pago, fecha)
           @pago= Pago.find(pago)
           @interes_moratorio = pago.credito.producto.moratorio
           if @fecha <= @pago.fecha_limite
             return false
           else
             @pago.moratorio = (@pago.capital_minimo.to_f + @pago.interes_minimo.to_f)*(@interes_moratorio)
             @pago.save!
             return true
           end
         end

       #----- Calculo de impores por retraso en pagos ---------

        def calcula_comisiones(pago, fecha_pago)
          comisiones = 0.0
          #---- Se calculan los gastos de cobranza ------
          #---- si es el mismo anio -----
          if fecha_pago.year == pago.fecha_limite.year
            if fecha_pago.yday - (pago.fecha_limite.yday)  >= 8 # 8 dias despues
               comisiones =  200 #if pago.comisiones != "0"
            end
          else
            #---- Es otro anio
            if fecha_pago.year - pago.fecha_limite.year == 1
              if (fecha_pago.yday + 365) - (pago.fecha_limite.yday)  >= 8 # 8 dias despues
                 comisiones = 200
              end
            end
          end
         return comisiones
        end

          def calcula_iva_comisiones(pago, fecha_pago)
            iva_comisiones = 0.0
            #---- Se calculan los gastos de cobranza ------
            #---- si es el mismo anio -----
            if fecha_pago.year == pago.fecha_limite.year
                if fecha_pago.yday - (pago.fecha_limite.yday)  >= 8 # 8 dias despues
                  iva_comisiones = 200 * 0.16
                end
            else
                #---- Es otro anio
                if fecha_pago.year - pago.fecha_limite.year == 1
                  if (fecha_pago.yday + 365) - (pago.fecha_limite.yday)  >= 8 # 8 dias despues
                     iva_comisiones = 200 * 0.16
                  end
                end
            end
            return iva_comisiones
          end


        def calcula_moratorio(pago, fecha_pago)
            interes_moratorio = pago.credito.producto.moratorio / 100.0
            moratorio = 0.0
            #--- checamos que sean del mismo año ----
            if fecha_pago.year == pago.fecha_limite.year
                if fecha_pago.yday - (pago.fecha_limite.yday)  >= 3 # 8 dias despues
                  cm = pago.capital_minimo.to_f
                  im = pago.interes_minimo.to_f
                  moratorio = (cm + im) * interes_moratorio # if pago.moratorio != "0"
                end
            else
              #---- Es un año despues ------
              if fecha_pago.year - pago.fecha_limite.year == 1
                  if fecha_pago.yday + 365 - (pago.fecha_limite.yday)  >= 3 # 8 dias despues
                    cm = pago.capital_minimo.to_f
                    im = pago.interes_minimo.to_f
                    moratorio = (cm + im) * interes_moratorio # if pago.moratorio != "0"
                  end
              end
            end
          return moratorio
        end


       def proximo_pago_minimo_por_cliente_a_la_fecha(cliente, credito, fecha)
          @proximo = Pago.find(:first, :conditions=>["credito_id = ? AND
                                                   cliente_id = ? AND
                                                   pagado=0", credito.id, cliente.id],
                                                   :order=>"fecha_limite")
          return (@proximo.capital_minimo.to_f) + (@proximo.interes_minimo.to_f) + calcula_moratorio(@proximo, fecha) + calcula_comisiones(@proximo, fecha) + calcula_iva_comisiones(@proximo, fecha)
       end
        


 


         def clientes_activos_grupo(grupo)
             @clientes = []
             @cg = Clientegrupo.find(:all, :conditions => ["grupo_id = ? and activo = 1", grupo.id])
             @cg.each do |cliente|
                 @clientes << cliente.cliente
             end
             return @clientes
         end

         def todos_grupos_conclientes
           #---- Validamos que el grupo teng
           ids = []
           @c = Clientegrupo.find(:all, :select => "grupo_id", :conditions => "activo = 1", :group => "grupo_id")
           @c.each{|x| ids << x.grupo_id}
           return @grupos = Grupo.find(ids)
         end

#         def todos_clientes_singrupo
#           ---- Validamos que el grupo teng
#           ids = []
#           @clientes = Cliente.find(:all, :select => "id, paterno, materno, nombre", :order => "paterno, materno, nombre")
#           @c = Clientegrupo.find(:all, :select => "cliente_id", :conditions => "activo = 1", :group => "cliente_id")
#           @c.each{|x| @clientes.delete(Cliente.find(x.cliente_id))}
#           return @clientes
#         end


         def todos_clientes_singrupo_join
            return Cliente.find_by_sql("select id, curp, paterno, materno, nombre from clientes where id not in (select c.id from clientes c, clientes_grupos cg where c.id=cg.cliente_id) order by paterno, materno, nombre")
         end




         def grupo_activo_cliente(cliente)
           return Clientegrupo.find(:first, :conditions => ["cliente_id = ? and activo = 1", cliente.id]).grupo
         end

         def creditos_activos_grupo(grupo)
           Credito.find(:all, :conditions => ["grupo_id = ? and st = 1", grupo.id])
         end

         def aplicar_transferencia(transferencia)
           #----- Primero restamos agregamos el total ---
           Transferencia.transaction do
              Transferencia.create(:title => 'en la transaccion', :content => 'texto')
              Post.create(:content => 'texto')
           end
         end

        def inserta_poliza(importe, cta, naturaleza)
    #      fecha, tipo_poliza, num_poliza, cta, naturaleza, importe, descripcion, identificador
           @num_poliza = Configuracion.find(:first, :select => "ultima_poliza", :conditions => "activo = 1").ultima_poliza += 1
           @poliza = Poliza.new
           @poliza.num_poliza = @num_poliza
           @poliza.fecha = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
           @poliza.naturaleza = naturaleza
           @poliza.importe = importe.to_s
           @poliza.cuenta = cta
           @poliza.descripcion = cta.sNombre
           @poliza.save!
        end

        def calcula_devengo_intereses(credito)
        @fecha_inicio = credito.fecha_inicio
        @mes = @fecha_inicio.month
        @tasa_diaria =  ((credito.producto.intereses.to_f / 100.0 ) / 30.0)
        @capital = (credito.monto / credito.grupo.clientes.size)
       # @fecha_inicio = DateTime.new(@anio.to_i, @mes.to_i, @dia.to_i, @hora.to_i, @minutos.to_i).strftime("%Y-%m-%d %H:%M:%S")
        #pago_semanal = 1000
        #tasa_interes = 0.03
        interes_diario = @capital * @tasa_diaria
        dia = 0
        semana = 1
        #---- Calculamos fechas de corte ---
        case dias_mes(@mes)
        when 31
          fechas_corte = [7, 14, 21, 28, 31]
        when 30
          fechas_corte = [7, 14, 21, 28, 30]
        when 28
          fechas_corte = [7, 14, 21, 28]
        else
          fechas_corte = [7, 14, 21, 28, 30]
        end

          sum_intereses = 0#interes_diario
          while dia <= dias_mes(@mes) && @fecha_inicio.month == credito.fecha_inicio.month && @fecha_inicio.year == credito.fecha_inicio.year do
                  if fechas_corte.include?(dia) && (@fecha_inicio.day <= dias_mes(@mes)) && @fecha_inicio.month == credito.fecha_inicio.month && @fecha_inicio.year == credito.fecha_inicio.year
                       @devengo = Devengo.new
                       @devengo.credito = credito
                       @devengo.dia = dia
                       @devengo.semana = semana
                       @devengo.fecha = @fecha_inicio
                       @devengo.generacion_obligacion = sum_intereses
                       @devengo.save!
                       @mes = @fecha_inicio.month
                       semana+=1
                       sum_intereses = 0
                  end
                #--- Incrementos ----
                dia += 1
                sum_intereses += interes_diario
                @fecha_inicio += 1
          end

          @fecha_inicio -= 1
           if (semana*7).to_i != dias_mes((@fecha_inicio).month).to_i
              @devengo = Devengo.new(:generacion_obligacion => sum_intereses, :fecha => @fecha_inicio, :dia => dia-1, :semana => semana )
              @devengo.credito = credito
              @devengo.save!
          end
        end


#--- respaldo de la funcion ---
def calcula_devengo_intereses_resp(credito)
        @fecha_inicio = credito.fecha_inicio
        @mes = @fecha_inicio.month
       # @fecha_inicio = DateTime.new(@anio.to_i, @mes.to_i, @dia.to_i, @hora.to_i, @minutos.to_i).strftime("%Y-%m-%d %H:%M:%S")
        pago_semanal = 1000
        tasa_interes = 0.03
        interes_diario = pago_semanal * tasa_interes
        dia = 1
        semana = 1
        #---- Calculamos fechas de corte ---
        case dias_mes(@mes)
        when 31
          fechas_corte = [7, 14, 21, 28, 31]
        when 30
          fechas_corte = [7, 14, 21, 28, 30]
        when 28
          fechas_corte = [7, 14, 21, 28]
        else
          fechas_corte = [7, 14, 21, 28, 30]
        end

          sum_intereses = interes_diario
          while dia <= dias_mes(@mes) do
                  if fechas_corte.include?(dia)
                       @devengo = Devengo.new
                       @devengo.credito_id = credito
                       @devengo.dia = dia
                       @devengo.semana = semana
                       @devengo.fecha = @fecha_inicio
                       @devengo.generacion_obligacion = sum_intereses
                       @devengo.save!
                       #@mes = @fecha_inicio.month
                       semana+=1
                       sum_intereses = 0
                  end
                #--- Incrementos ----
                dia += 1
                sum_intereses += interes_diario
#   case dias_mes(@mes)
#        when 31
#          fechas_corte = [7, 14, 21, 28, 31]
#        when 30
#          fechas_corte = [7, 14, 21, 28, 30]
#        when 28
#          fechas_corte = [7, 14, 21, 28]
#        else
#          fechas_corte = [7, 14, 21, 28, 30]
#    end
#
                @fecha_inicio += 1
#
          end
        end



#------ Calculo de los devengos diarios de acuerdo al tipo del calculo de intereses --------

def devengo_diario_pagos_iguales_decremento_incremento(tasa_anualizada, num_dias, capital)
  return ((((tasa_anualizada/360.0)* num_dias) * capital) / num_dias)
end


def devengo_diario_pagos_iguales_capital(tasa_anualizada, num_dias, capital)
  return ((((tasa_anualizada/360.0)* num_dias) * capital) / num_dias)
end


def devengo_diario_pagos_flat(tasa_mensual, capital)
  return (tasa_mensual * capital/ 30.0)
end


def lista_pagos_unicos_credito(credito)
  return Pago.find(:all, :conditions => ["credito_id = ?", credito.id], :group => "num_pago")
end

def numero_clientes_grupo(grupo)
  return 0 if grupo.nil?
  return Clientegrupo.count(:id, :conditions => ["grupo_id = ? and activo = 1", grupo.id])
end

def localidad_grupo(grupo)
  return (grupo.clientegrupos[0].cliente.localidad.localidad)
end

def municipio_grupo(grupo)
  return (grupo.clientegrupos[0].cliente.localidad.municipio.municipio)
end



end