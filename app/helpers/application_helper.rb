# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    #---- Funciones que pueden ser usadas desde cualquier vista ----
    def controllers_by_rol(rol)
    @rol = Rol.find(rol)
    return @rol.systables
  end

    def tiene_permiso?(rol, controlador)
      @registro = Systable.find(:first, :conditions => ["rol_id = ? and controller = ? ", Rol.find(rol).id, controlador])
      if @registro.nil?
         false
      else
         true
      end
    end

          def proximo_pago(credito)
          @proximo = Pago.find(:first, :conditions=>["credito_id = ? AND
                                                   pagado=0", credito.id],
                               :order=>"fecha_limite")
                             return @proximo


        end



       def todos_controladores
          @arreglo_controllers = Array.new
          @controllers = Systable.find(:all, :select => ["distinct(controller)"])
          @controllers.each{|x|
            @arreglo_controllers << Systable.find(:first,
              :conditions => ["controller = ?", x.controller])}
          return @arreglo_controllers
       end

       #---- Funciones del crédito -----
    def cargos(credito)
    @arreglo = []
    @movimientos = credito.movimientos
    if @movimientos.empty?
      #el cliente no ha realizado ningun pago
        return false
    else

    @movimientos.each { | movimiento|
              if movimiento.tipo=="C"
                     @arreglo << movimiento
              end
     }
     return @arreglo
     end
  end

    def abonos(credito)
    @arreglo = []
    @movimientos = credito.movimientos
    if @movimientos.empty?
      #el cliente no ha realizado ningun pago
        return false
    else

    @movimientos.each { | movimiento|
              if movimiento.tipo =="A"
                     @arreglo << movimiento
              end
     }
     return @arreglo
     end
end


      def liquido(credito)
    @abonos = 0
    @cargos = 0
    @movimientos = credito.movimientos
    if @movimientos.empty?
      #el cliente no ha realizado ningun pago
        return ( credito.monto * credito.tasa_interes / 100 ) + credito.monto

    else

    @movimientos.each { | movimiento|
      if movimiento.tipo=="C"
          @cargos = movimiento.capital += @cargos
      end

      if movimiento.tipo=="A"
          @abonos = movimiento.capital += @abonos
      end

    }
      return (credito.monto * (credito.tasa_interes / 100 ) + credito.monto ) + @cargos - @abonos
  end
end


        def pago_minimo(credito)
        #--- Verificamos si el credito ha sido cubierto ----
        @monto = credito.monto
        @interes = credito.tasa_interes / 100.0
        return((@monto * @interes) + @monto) / @credito.num_pagos
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


  




end
