require 'date'
class Vencimiento
  
  def initialize(credito=nil, fecha_calculo=DateTime.now)
      @fecha_calculo = fecha_calculo
      @credito = credito
      @gastos_cobranza = 0
      @capital_vencido = 0
      @cuota_diaria = 0
      @moratorio = 0
      @dias_atraso = 0
      @intereses_devengados = 0
      @devengo_diario = 0
  end

  attr_accessor :credito, :pago_diario, :dias_atraso, :moratorio, :gastos_cobranza, :capital_vencido, :cuota_diaria, :fecha_calculo, :intereses_devengados, :devengo_diario
  
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
       @gastos_cobranza = 200 if dias_transcurridos > 8
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

      #puts periodos_transcurridos(credito)

   end


  end


  def procesar
     credito = @credito
     dias_transcurridos = DateTime.now.yday - proximo_pago(credito).fecha_limite.yday
     periodos_transcurridos_sin_pagar = periodos_sin_pagar(credito)
      todos_los_pagos = Pago.find(:all, :conditions => ["credito_id = ? and pagado = 0", credito.id], :order => "num_pago", :group => "cliente_id")
      pagos_vencidos = todos_los_pagos[0..periodos_transcurridos_sin_pagar - 1]
      pagos_vencidos.each{|pago| @capital_vencido+=pago.capital_minimo.to_f}
      if dias_transcurridos > 0
       pago_diario = pago_minimo_informativo(credito) / credito.producto.periodo.dias.to_f
       moratorio_diario = ((credito.producto.moratorio / 100.0 ) * proximo_pago(credito).capital_minimo.to_f ) / credito.producto.periodo.dias.to_f
       @devengo_diario = proximo_pago(credito).interes_minimo.to_f / credito.producto.periodo.dias.to_f
       @gastos_cobranza = 200 if dias_transcurridos > 8
       #---- Globales --
       @moratorio = moratorio_diario * dias_transcurridos.to_f
       @cuota_diaria = moratorio_diario + pago_diario
       @intereses_devengados = @devengo_diario * dias_transcurridos.to_f
       pago_minimo = pago_minimo_informativo(credito)
       puts "Capital minimo por periodo => #{proximo_pago(credito).capital_minimo}"
       puts "Pago diario (C + I) / dias = #{pago_diario}"
       puts "Couta diaria por atraso => #{moratorio_diario + pago_diario}"
       puts "Dias de atraso => #{dias_transcurridos}"
       puts "Moratorio => #{@moratorio}"
       puts "Gastos de Cobranza => #{@gastos_cobranza}"
       puts "Capital + Interes Normales => #{pago_minimo}"
       puts "Capital Vencido hasta hoy => #{@capital_vencido}"
       puts "------- Total a pagar => #{@gastos_cobranza + @moratorio + @capital_vencido}"
      end
      dias_transcurridos = 0 if dias_transcurridos < 0
      @dias_atraso =dias_transcurridos
  end




end