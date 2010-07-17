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


  def cargos(credito)
      @pagos = Pago.find(:all,
                         :conditions=>["credito_id = ? AND pagado= 1", credito.id])
    sum=0
    @pagos.each do |pago|
      sum +=  pago.interes.to_f
    end
    return sum
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
    return @interes + @capital
  end

  def pago_minimo(credito)
          #--- Verificamos si el credito ha sido cubierto ----
       @interes_moratorio = Configuracion.find(:first, :select=>"interes_moratorio").interes_moratorio.to_f / 100.0
       @proximo_pago= proximo_pago(credito)
       if Time.now.to_date <= @proximo_pago.fecha_limite
         return @proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f
       else
         return ((@proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f)*(@interes_moratorio)) + @proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f
       end
  end


#  def capital_minimo(credito)
#      return credito.monto / @credito.num_pagos.to_f
#  end

#  def interes_minimo(credito)
#          @monto = credito.monto
#          @interes = credito.tasa_interes / 100.0
#          return(@monto * @interes) / @credito.num_pagos
#  end


  #---- Funciones grupales------
  def capital_minimo_grupal(credito)
      @miembros = credito.grupo.clientes.size
      return (credito.monto / @miembros) / @credito.num_pagos.to_f
  end

  def interes_minimo_grupal(credito)
          @miembros = credito.grupo.clientes.size
          @monto = credito.monto
          @interes = credito.tasa_interes / 100.0
          return((@monto / @miembros) * @interes) / @credito.num_pagos
  end

  def proximo_pago(credito)
          @proximo = Pago.find(:first, :conditions=>["credito_id = ? AND
                                                   pagado=0", credito.id],
                                                   :order=>"fecha_limite")
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
                             :capital_minimo => capital_minimo(credito),
                             :interes_minimo => interes_minimo(credito),
                             :pagado => 0,
                             :descripcion => "Pago #{contador} de #{arreglo_pagos.size} capital minimo #{capital_minimo(credito)} ")
                 contador+=1
            end
         else
           return nil
         end
    end


  def inserta_pagos_grupales(credito, arreglo_pagos)
       if credito.pagos.size == 0
         #--- Hacemos una iteracion por todos los miembros del grupo y dividimos el total del credito ---
         credito.grupo.clientes.each do |y|
           contador=1
            arreglo_pagos.each do |x|
                   Pago.create(:num_pago => contador,
                             :credito_id => credito.id.to_i,
                             :fecha_limite => x,
                             :cliente_id => y.id.to_i,
                             :capital_minimo => capital_minimo_grupal(credito),
                             :interes_minimo => interes_minimo_grupal(credito),
                             :pagado => 0,
                             :descripcion => "Pago #{contador} de #{arreglo_pagos.size} capital minimo #{capital_minimo_grupal(credito)} ")
                 contador+=1
               end
            end
       else
           return nil
       end
    end


    def linea_disponible(linea)
        if linea.creditos.empty?
           return linea.autorizado
        else
           return (linea.autorizado - Credito.sum(:monto, :conditions=>["linea_id = ?", linea.id])/1.0)
        end
    end

   
        def cargos?(pago, fecha)
           @pago= Pago.find(pago)
           @interes_moratorio = Configuracion.find(:first, :select=>"interes_moratorio").interes_moratorio.to_f / 100.0
           if @fecha <= @pago.fecha_limite
             return false
           else
             @pago.moratorio = (@pago.capital_minimo.to_f + @pago.interes_minimo.to_f)*(@interes_moratorio)
             @pago.save!
             return true
           end
         end

end