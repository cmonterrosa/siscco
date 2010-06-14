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

  



       def todos_controladores
          @arreglo_controllers = Array.new
          @controllers = Systable.find(:all, :select => ["distinct(controller)"])
          @controllers.each{|x|
            @arreglo_controllers << Systable.find(:first,
              :conditions => ["controller = ?", x.controller])}
          return @arreglo_controllers
       end

       ###############################################
       #            Funciones del crédito            #
       ###############################################



  def abonos(credito)
    @pagos = Pago.find(:all,
                       :conditions=>["credito_id = ? AND pagado= 1", credito.id])
    sum=0
    @pagos.each do |pago|
      sum +=  pago.capital
    end
    return sum
  end

  def cargos(credito)
      @pagos = Pago.find(:all,
                       :conditions=>["credito_id = ? AND pagado= 1", credito.id])
    sum=0
    @pagos.each do |pago|
      sum +=  pago.interes
    end
    return sum

  end

  def total(credito)
    @total =  (credito.monto * credito.tasa_interes ) + credito.monto
    return @total - abonos(credito)
 end







        def proximo_pago(credito)
          @proximo = Pago.find(:first, :conditions=>["credito_id = ? AND
                                                   pagado=0", credito.id],
                               :order=>"fecha_limite")
          return @proximo
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



        def linea_disponible(linea)
          if linea.creditos.empty?
            return linea.autorizado
          else
            return (linea.autorizado - Credito.sum(:monto, :conditions=>["linea_id = ?", linea.id])/1.0)
          end
        end



  




end
