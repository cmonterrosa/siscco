require 'date'
class Vencimiento
  def initialize(credito=nil, fecha_calculo=nil, tablaexcedente=nil)
      if fecha_calculo
         @fecha_calculo = fecha_calculo
      else
         @fecha_calculo = DateTime.now
      end
      if tablaexcedente
        @tabla_excedente=tablaexcedente
      else
        @tabla_excedente = "depositos"
      end
      @credito = credito
      @gastos_cobranza = 0
      @capital_vencido = 0
      @interes_vencido = 0
      @cuota_diaria = 0
      @pago_diario = 0
      @moratorio = 0
      @iva_moratorio=0
      @iva_gastos_cobranza=0
      @dias_atraso = 0
      @intereses_devengados = 0
      @devengo_diario = 0
      @total_deuda = 0
      @total_deuda_individual = 0
      #---- Valores dinámicos para iva y gastos de cobranza ---
      if credito.producto.iva
        @tasa_iva = (credito.producto.iva / 100.0)
      else
        @tasa_iva = 0.16
      end
      if credito.producto.gastos_cobranza
        @cuota_gastos_cobranza = credito.producto.gastos_cobranza.to_f
      else
        @cuota_gastos_cobranza = 200
      end
      @clientes = Clientegrupo.find(:all, :select => "id, fecha_fin, activo", :conditions => ["grupo_id = ? AND activo=1",credito.grupo.id.to_i])
      @numero_clientes = @clientes.size
      @excendente_deposito=0.0
      @periodos_sin_pagar = 0
      @pagos_vencidos = nil
      @proximo_pago_string = " "
      @liquidado=false
      @tasa_moratoria_mensual= 0
      if credito.tipo_interes == "SALDOS INSOLUTOS (SSI)"
        if @credito.producto.moratorio_ssi
           @tasa_moratoria_mensual = ((@credito.producto.moratorio_ssi.to_f / 100.0) / 12.0)
           
        else
           @tasa_moratoria_mensual = (((@credito.producto.tasa_anualizada.to_f * 2.0) / 100.0) / 12.0)
        end
        @tasa_normal_mensual = round((((@credito.producto.tasa_anualizada.to_f) / 360.0 ) * 30), 4)
      else
        if @credito.producto.moratorio_flat
           @tasa_moratoria_mensual = (@credito.producto.moratorio_flat.to_f / 100.0)
        end
        @tasa_normal_mensual = @credito.producto.tasa_mensual_flat.to_f
      end
      #---- Proporciones ---
      @proporcion_capital = 0
      @proporcion_interes = 0
      #---- importes de las proporciones ---
      @importe = 0
      @capital_total = 0
  end

  attr_accessor :credito, :pago_diario, :dias_atraso, :moratorio, :gastos_cobranza, :capital_vencido, :cuota_diaria, :fecha_calculo, :intereses_devengados, :devengo_diario, :interes_vencido, :numero_clientes, :iva_moratorio, :iva_gastos_cobranza, :total_deuda, :proximo_pago_string, :liquidado, :tasa_iva, :cuota_gastos_cobranza, :proporcion_interes, :proporcion_capital, :pagos_vencidos, :total_deuda_individual, :capital_total
  

  def procesar
     calcular_proporciones
     calcular_capital_total
     # Validaremos si ya termino de pagar
     unless credito_pagado?
        calcular_vencimientos
     else
       liberar_credito if @liquidado==false
     end
          #impresiones en pantalla
#          puts "Proporcion Capital => #{@proporcion_capital}"
#          puts "Proporcion Interes => #{@proporcion_interes}"
#          puts "Dias de atraso => #{@dias_atraso}"
#          puts "Capital Vencido => #{@capital_vencido}"
#          puts "Intereses Vencidos => #{@interes_vencido}"
#          puts "Moratorio => #{@moratorio}"
#          puts "Gastos de Cobranza => #{@gastos_cobranza}"
#          puts "------- Total a pagar => #{@total_deuda}"
  end


  #-- metodo que calculo vencimientos adelantados para pronto pago ---

  def procesar_pagos_adelantados(importe)
    @importe = importe.to_f
    @pagado_bandera=false
    calcular_proporciones
    @pagos_sin_liquidar = Pagogrupal.find(:all, :conditions => ["credito_id = ? AND pagado = 0", @credito.id], :order => "num_pago")
    @pagos_sin_liquidar.each do |pago|
      #---- vamos a ver si alcanza para pagar algo adelantado ----
      #--- buscamos el detalle de los pagos ----
      detalle_pagos = Pago.find(:all, :conditions => [" credito_id = ? and num_pago = ?", @credito.id, pago.num_pago])
      if @importe >= (pago.capital_minimo + pago.interes_minimo)
        #---- Capital e interes -----
        Pago.transaction do
          begin
            pago.update_attributes!(:pagado => 1)
            detalle_pagos.each do |p| p.update_attributes!(:pagado => 1) end
            @importe-=pago.capital_minimo
            @importe-=pago.interes_minimo
            @pagado_bandera=true
          rescue ActiveRecord::StatementInvalid
          end
        end

      else

       #--- hacemos el calculo de proporciones para el sobrante ----
       Pago.transaction do
         begin
          importe_capital = @proporcion_capital * @importe
          importe_interes = @proporcion_interes * @importe
          importe_individual_capital = importe_capital / @numero_clientes * 1.0
          importe_individual_interes = importe_interes / @numero_clientes * 1.0
          #---- lo aplicamos ---
          p_capital_minimo = pago.capital_minimo.to_f - importe_capital.to_f
          p_interes_minimo = pago.interes_minimo.to_f - importe_interes.to_f
          pago.update_attributes!(:capital_minimo => p_capital_minimo, :interes_minimo => p_interes_minimo)
          detalle_pagos.each{|p|
              p_capital_minimo_individual = p.capital_minimo.to_f - importe_individual_capital.to_f
              p_interes_minimo_individual = p.interes_minimo.to_f - importe_individual_interes.to_f
              p.update_attributes!(:capital_minimo => p_capital_minimo_individual, :interes_minimo => p_interes_minimo_individual)
              p.update_attributes!(:principal_recuperado => p.capital_minimo)
          }
          @importe-= importe_capital
          @importe-= importe_interes
          @pagado_bandera=true
          rescue ActiveRecord::StatementInvalid
          end
         
       end
     end
    end
    calcular_capital_total
    return @pagado_bandera
  end

 

  def calcular_vencimientos
     credito = @credito
     sum_moratorio=0
     #--- Validaremos si es otro año ----
     hoy = @fecha_calculo.yday
     anio_calculo = @fecha_calculo.year
     anio_proximo_pago = proximo_pago(credito).fecha_limite.year
     dia_proximo_pago = proximo_pago(credito).fecha_limite.yday
    if anio_proximo_pago > anio_calculo
      # el proximo pago es del siguiente anio
      dias_transcurridos = 0
    else
      if anio_proximo_pago < anio_calculo
        # el proximo pago es del aaños anteriores, es decir esta vencido
        dias_transcurridos = ((365 * (anio_calculo - anio_proximo_pago)) - dia_proximo_pago + hoy).to_i
      else
        #--- son del mismo año --
        dias_transcurridos = (hoy - dia_proximo_pago).to_i
      end
    end

      if dias_transcurridos > 0
         @periodos_sin_pagar = periodos_transcurridos_sin_pagar = periodos_sin_pagar(credito,@fecha_calculo)
         todos_los_pagos = Pagogrupal.find(:all, :conditions => ["credito_id = ? and pagado = 0", credito.id], :order=>"num_pago")
         @pagos_vencidos = todos_los_pagos[0..periodos_transcurridos_sin_pagar - 1]
         periodos_vencidos=0
         @pagos_vencidos.each{|pago|
         @capital_vencido+=pago.principal_recuperado.to_f #-- sumamos capital vencido
         @interes_vencido += (pago.interes_minimo.to_f)
          sum_moratorio += (pago.principal_recuperado.to_f * @tasa_moratoria_mensual / 30.0) * dias_por_cobrar(@fecha_calculo, pago.fecha_limite)
          periodos_vencidos+=1
         }
          @moratorio = round(sum_moratorio / (1+@tasa_iva))
          @iva_moratorio = round(sum_moratorio  - @moratorio)
          #--- Gastos de cobranza ---
          @gastos_cobranza = round(((periodos_vencidos - 1) * (@cuota_gastos_cobranza) ) / (1+@tasa_iva))
          @iva_gastos_cobranza = round((((periodos_vencidos -1) * (@cuota_gastos_cobranza)) - @gastos_cobranza))
          #---- Globales --
          moratorio_diario = 0
          @cuota_diaria = moratorio_diario + @pago_diario
          @intereses_devengados = @devengo_diario * dias_transcurridos.to_f
      end

    #--- si no tiene periodos pendientes y esta pagando en la fecha exacta -----
      if (@periodos_sin_pagar == 0) && (hoy == proximo_pago(credito).fecha_limite.yday)
          @capital_vencido = proximo_pago(credito).principal_recuperado.to_f
          @interes_vencido = (proximo_pago(credito).interes_minimo.to_f)
      end
      @total_deuda = @capital_vencido + @interes_vencido + @iva_gastos_cobranza + @gastos_cobranza + @iva_moratorio + @moratorio
      @total_deuda_individual = @total_deuda / @numero_clientes
      dias_transcurridos = 0 if dias_transcurridos < 0
      @dias_atraso =dias_transcurridos
      @proximo_pago_string = proximo_pago(credito).fecha_limite.to_s

   end


 def aplicar_depositos(importe, datafile_id=nil, tipo=nil )
       tipo="deposito" unless tipo
       total=importe
                  # ......... Orden de Aplicacion ........
                  #IVA POR COMISIONES COBRADAS
                  #COMISIONES COBRADAS
                  #IVA POR INTERESES MORATORIOS
                  #INTERESES MORATORIOS
                  #IVA POR INTERESES NORMALES
                  #INTERESES NORMALES
                  #CAPITAL
     if total >= @total_deuda && @liquidado==false
        #metemos la transaccion
        Transaccion.transaction do
                   #... iva por comisiones
                   Transaccion.create(:monto => @iva_gastos_cobranza.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(1).id,
                                      :fecha_hora_aplicacion=>Time.now, :datafile_id => datafile_id)
                   total-=@iva_gastos_cobranza
                   #... comisiones
                   Transaccion.create(:monto => @gastos_cobranza.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(2).id,
                                      :fecha_hora_aplicacion=>Time.now, :datafile_id => datafile_id)
                   total-=@gastos_cobranza
                   #.... Iva moratorio
                   Transaccion.create(:monto => @iva_moratorio.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(3).id,
                                      :fecha_hora_aplicacion=>Time.now, :datafile_id => datafile_id)
                   total-=@iva_moratorio
                   #.... moratorio
                   Transaccion.create(:monto => @moratorio.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(4).id,
                                      :fecha_hora_aplicacion=>Time.now, :datafile_id => datafile_id)
                   total-=@moratorio
                   #.... intereses normales
                   Transaccion.create(:monto => @interes_vencido.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(5).id,
                                      :fecha_hora_aplicacion=>Time.now, :datafile_id => datafile_id)
                   total-=@interes_vencido
                   #.... capital
                   Transaccion.create(:monto => @capital_vencido.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(6).id,
                                      :fecha_hora_aplicacion=>Time.now, :datafile_id => datafile_id)
                   total-=@capital_vencido
                   #... cambiamos estatus....
              end #--- termina la transaccion-------
              
                   #---- actualizacion de estatus --------
                   update_estatus_pagos
                   #---- Aqui cambiamos el estatus del deposito----
                   if tipo == "fecha_valor"
                      update_estatus_fvalor
                   else
                      update_estatus_deposito
                   end

                   if total > 0
                      @excedente_deposito=total.to_f.abs
                      insert_excedente_deposito(@tablaexcedente) if @excedente_deposito > 0
                   end
              return true

     else
         return false
     end
     #---- Aqui vamos a verificar si ya termino de pagar ----
     calcular_capital_total
     if credito_pagado?
        liberar_credito
     end
end

 protected

 def liberar_credito
        @credito.update_attributes!(:status=>1, :fecha_fin => Date.strptime(@fecha_calculo.to_s))
        @clientes.each do |cliente|
            if cliente.activo == 1 && !cliente.fecha_fin
              cliente.update_attributes!(:activo => 0, :fecha_fin => Date.strptime(@fecha_calculo.to_s))
            end
        end
 end

 def update_estatus_pagos
   unless @pagos_vencidos.nil?
    @pagos_vencidos.each do |pagovencido|
         pagovencido.update_attributes!(:pagado => 1)
         @pagos = Pago.find(:all, :conditions => ["credito_id = ? and num_pago = ?", @credito.id, pagovencido.num_pago]).each do |pago|
            pago.update_attributes!(:pagado => 1)
         end
      end
   end
 end

 def update_estatus_deposito
   Deposito.find(:all, :conditions => ["credito_id = ?", @credito.id]).each do |deposito|
         deposito.update_attributes!(:st => "A")
   end
 end

  def update_estatus_fvalor
   FechaValor.find(:all, :conditions => ["credito_id = ?", @credito.id]).each do |deposito|
         deposito.update_attributes!(:st => "A")
   end
 end

 def insert_excedente_deposito(tablaexcedente)
     if @excedente_deposito > 0.0
         case tablaexcedente
         when "fechavalor"
              Fechavalor.create(:importe => @excedente_deposito, :ref_alfa=>@credito.num_referencia, :credito_id => @credito.id, :st => "A")
         else
              Deposito.create(:importe => @excedente_deposito, :ref_alfa=>@credito.num_referencia, :ref_num=>@credito.num_referencia, :credito_id => @credito.id)
         end
     end
 end

 def credito_pagado?
   globales = Pagogrupal.find(:all, :conditions => ["pagado = 0 and credito_id = ?", @credito])
   detallados = Pago.find(:all, :conditions => ["pagado = 0 and credito_id = ?", @credito])
   if globales.empty?
     #--- actualizamos la tabla de pagos detallados --
     detallados.each{|d|d.update_attributes!(:pagado=>1)} unless detallados.empty?
     @proximo_pago_string = "Crédito liquidado"
     @liquidado=true
     return true
   else
     return false
   end
 end

 #---- Calculo de dias por pagar ---
  def dias_por_cobrar(hoy, fecha)
    anio_hoy = hoy.year
    yday_hoy = hoy.yday
    anio_fecha = fecha.year
    yday_fecha = fecha.yday
    if anio_hoy == anio_fecha
      return yday_hoy - yday_fecha
    else
      return (yday_hoy + 365 * (hoy.year - fecha.year)) - yday_fecha
    end
  end

  #--- Calculo de proporciones ---
  def calcular_proporciones
    meses = @credito.producto.num_pagos / @credito.producto.periodo.pagos_mes
    interes_total_vida_credito = @tasa_normal_mensual * meses
    total_recuperar = 100 + interes_total_vida_credito
    @proporcion_capital = (100.0 / total_recuperar)
    @proporcion_interes = (interes_total_vida_credito / total_recuperar)
  end

  def calcular_capital_total
    @capital_total = Pagogrupal.sum(:capital_minimo, :conditions => ["credito_id = ? and pagado=0", @credito.id])
  end




 

end