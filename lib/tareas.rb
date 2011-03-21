require 'date'
class Vencimiento
  
  def initialize(credito=nil, fecha_calculo=nil, tablaexcedente=nil)
      if fecha_calculo
         @fecha_calculo = fecha_calculo#.to_date if fecha_calculo.strftime =~ /^\d{1,2}[-|\/]\d{1,2}[-|\/]\d{2,4}$/
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
      @numero_clientes = Clientegrupo.count(:id, :conditions => ["grupo_id = ? AND activo=1",credito.grupo.id.to_i])
      @excendente_deposito=0.0
      @periodos_sin_pagar = 0
      @pagos_vencidos = nil
 
  end

  attr_accessor :credito, :pago_diario, :dias_atraso, :moratorio, :gastos_cobranza, :capital_vencido, :cuota_diaria, :fecha_calculo, :intereses_devengados, :devengo_diario, :interes_vencido, :numero_clientes, :iva_moratorio, :iva_gastos_cobranza, :total_deuda
  
  def all
   #---- Vamos a contabilizar los dias de atraso ---
   #--- Iteramos sobre todos los creditos ---
   Credito.find(:all, :conditions=> "status=0").each do |credito|
      dias_transcurridos = DateTime.now.yday - proximo_pago(credito).fecha_limite.yday
      periodos_transcurridos_sin_pagar = periodos_sin_pagar(credito)
      todos_los_pagos = Pago.find(:all, :conditions => ["credito_id = ? and pagado = 0", credito.id], :order => "num_pago", :group => "cliente_id")
      pagos_vencidos = todos_los_pagos[0..periodos_transcurridos_sin_pagar - 1]
      pagos_vencidos.each{|pago| @sumatoria_capital_vencido+=pago.capital_minimo.to_f}
      if dias_transcurridos > 0
       pago_diario = pago_minimo_informativo(credito) / credito.producto.periodo.dias.to_f
       moratorio_diario = ((credito.producto.moratorio / 100.0 ) * proximo_pago(credito).capital_minimo.to_f ) / credito.producto.periodo.dias.to_f
       @gastos_cobranza = (dias_transcurridos / 8) * 200
       #---- Globales --
       moratorio = moratorio_diario * dias_transcurridos.to_f
       gastos_cobranza = @gastos_cobranza
       pago_minimo = pago_minimo_informativo(credito)
       puts "Capital minimo por periodo => #{proximo_pago(credito).capital_minimo}"
       puts "Pago diario (C + I) / dias = #{pago_diario}"
       puts "Couta diaria por atraso => #{moratorio_diario + pago_diario}"
       puts "Dias de atraso => #{dias_transcurridos}"
       puts "Moratorio => #{moratorio}"
       puts "Gastos de Cobranza => #{gastos_cobranza}"
       puts "Capital + Interes Normales => #{pago_minimo}"
       puts "Capital Vencido hasta hoy => #{@sumatoria_capital_vencido}"
       puts "------- Total a pagar => #{gastos_cobranza + moratorio + @sumatoria_capital_vencido}"
      end
   end


  end


  def procesar
     credito = @credito
     moratorio_diario = (@credito.producto.moratorio.to_f / 100.0) / 360.0
     tasa_diaria_moratoria = round((@credito.producto.moratorio.to_f / 100.0) / 360.0, 4)
     sum_moratorio=0
     #--- Validaremos si es otro año ----
     hoy = @fecha_calculo.yday
      if @fecha_calculo.year > proximo_pago(credito).fecha_limite.year
        hoy+=365 * (@fecha_calculo.year - proximo_pago(credito).fecha_limite.year)
      end
     dias_transcurridos = (hoy - proximo_pago(credito).fecha_limite.yday).to_i
     if dias_transcurridos > 0
         @periodos_sin_pagar = periodos_transcurridos_sin_pagar = periodos_sin_pagar(credito,@fecha_calculo)
        #todos_los_pagos = Pago.find(:all, :conditions => ["credito_id = ? and pagado = 0", credito.id], :order => "num_pago", :group => "num_pago")
         todos_los_pagos = Pagogrupal.find(:all, :conditions => ["credito_id = ? and pagado = 0", credito.id], :order=>"num_pago")
         @pagos_vencidos = todos_los_pagos[0..periodos_transcurridos_sin_pagar - 1]
         @pagos_vencidos.each{|pago|
         @capital_vencido+=pago.principal_recuperado.to_f #-- sumamos capital vencido
         @interes_vencido += (pago.interes_minimo.to_f)
          #--- Calculamos el moratorio para el periodo ---
          dias_por_cobrar = hoy - pago.fecha_limite.yday
          p_recuperado_global = pago.principal_recuperado.to_f 
          sum_moratorio += ((p_recuperado_global * tasa_diaria_moratoria) * dias_por_cobrar)
         }
      

      @moratorio = round(sum_moratorio * 0.84,2)
      @iva_moratorio = round(sum_moratorio * 0.16 ,2)
      #--- Vamos a multiplicarlo por el numero de clientes del grupo --
      #@capital_vencido = round(@capital_vencido,2)
      # @pago_diario = pago_minimo_informativo(credito) / credito.producto.periodo.dias.to_f
          #moratorio_diario = ((credito.producto.moratorio / 100.0 ) * proximo_pago(credito).capital_minimo.to_f ) / credito.producto.periodo.dias.to_f
       #   @devengo_diario = proximo_pago(credito).interes_minimo.to_f / credito.producto.periodo.dias.to_f
          #@gastos_cobranza = 200.00 if dias_transcurridos > 8
          @gastos_cobranza = ((dias_transcurridos / 8) * 200)* 0.84
          @iva_gastos_cobranza = ((dias_transcurridos / 8) * 200) * 0.16
          #---- Globales --
          moratorio_diario = 0
          @cuota_diaria = moratorio_diario + @pago_diario
          @intereses_devengados = @devengo_diario * dias_transcurridos.to_f
          @total_deuda=0
          puts "Dias de atraso => #{dias_transcurridos}"
          puts "Capital Vencido => #{@capital_vencido}"
          puts "Intereses Vencidos => #{@interes_vencido}"
          puts "Moratorio => #{@moratorio}"
          puts "Gastos de Cobranza => #{@gastos_cobranza}"
          puts "------- Total a pagar => #{@total_deuda}"
      end

    #--- si no tiene periodos pendientes y esta pagando en la fecha exacta -----
      if (@periodos_sin_pagar == 0) && (hoy == proximo_pago(credito).fecha_limite.yday)
          @capital_vencido = proximo_pago(credito).principal_recuperado.to_f
          @interes_vencido = (proximo_pago(credito).interes_minimo.to_f)
      end
      @total_deuda = @capital_vencido + @interes_vencido + @iva_gastos_cobranza + @gastos_cobranza + @iva_moratorio + @moratorio
      dias_transcurridos = 0 if dias_transcurridos < 0
      @dias_atraso =dias_transcurridos
  end



 def aplicar_depositos(importe)
        total=importe
                  # ......... Orden de Aplicacion ........
                  #IVA POR COMISIONES COBRADAS
                  #COMISIONES COBRADAS
                  #IVA POR INTERESES MORATORIOS
                  #INTERESES MORATORIOS
                  #IVA POR INTERESES NORMALES
                  #INTERESES NORMALES
                  #CAPITAL
     if total >= @total_deuda
        #metemos la transaccion
        Transaccion.transaction do
                   #... iva por comisiones
                   Transaccion.create(:monto => @iva_gastos_cobranza.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(1).id,
                                      :fecha_hora_aplicacion=>Time.now)
                   total-=@iva_gastos_cobranza
                   #... comisiones
                   Transaccion.create(:monto => @gastos_cobranza.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(2).id,
                                      :fecha_hora_aplicacion=>Time.now)
                   total-=@gastos_cobranza
                   #.... Iva moratorio
                   Transaccion.create(:monto => @iva_moratorio.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(3).id,
                                      :fecha_hora_aplicacion=>Time.now)
                   total-=@iva_moratorio
                   #.... moratorio
                   Transaccion.create(:monto => @moratorio.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(4).id,
                                      :fecha_hora_aplicacion=>Time.now)
                   total-=@moratorio
                   #.... intereses normales
                   Transaccion.create(:monto => @interes_vencido.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(5).id,
                                      :fecha_hora_aplicacion=>Time.now)
                   total-=@interes_vencido
                   #.... capital
                   Transaccion.create(:monto => @capital_vencido.to_f,
                                      :pagogrupal_id => proximo_pago(@credito).id,
                                      :tipo_transaccion_id => TipoTransaccion.find_by_prioridad(6).id,
                                      :fecha_hora_aplicacion=>Time.now)
                   total-=@capital_vencido
                   #... cambiamos estatus....
              end #--- termina la transaccion-------
              
                   #---- actualizacion de estatus --------
                   update_estatus_pagos
                   #---- Aqui cambiamos el estatus del deposito----
                   update_estatus_deposito
                   if total > 0
                      @excedente_deposito=total.to_f.abs
                      insert_excedente_deposito(@tablaexcedente)
                   end
              return true

     else
         return false
     end
end

 protected
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

 def insert_excedente_deposito(tablaexcedente)
     if @excedente_deposito > 0.0
         case tablaexcedente
         when "fechavalor"
              Fechavalor.create(:importe => @excedente_deposito, :ref_alfa=>@credito.num_referencia, :credito_id => @credito.id)
         else
              Deposito.create(:importe => @excedente_deposito, :ref_alfa=>@credito.num_referencia, :ref_num=>@credito.num_referencia, :credito_id => @credito.id)
         end
     end
 end

 

end