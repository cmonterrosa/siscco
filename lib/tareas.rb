require 'date'
class Vencimiento
  
  def initialize(fecha=DateTime.now)
     @fecha = fecha   
  end
  
  def now
   #---- Vamos a contabilizar los dias de atraso ---
   #--- Iteramos sobre todos los creditos ---
   @gastos_cobranza = 0
   @sumatoria_capital_vencido = 0
   Credito.find(:all, :conditions=> "status=0").each do |credito|
      dias_transcurridos = DateTime.now.yday - proximo_pago(credito).fecha_limite.yday
      puts "Aqui credito lleva el valor #{credito.id}"
      periodos_transcurridos_sin_pagar = periodos_sin_pagar(credito)
      pagos = Pago.find(:all, :conditions => "credito_id = ? and pagado = 0")
      capitales = pagos[0..periodos_transcurridos_sin_pagar - 1].capital_minimo
      capitales.each{|capital| @sumatoria_capital_vencido+=capital.to_f}
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



end