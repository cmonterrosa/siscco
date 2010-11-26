require 'date'

module Utilerias

  def separar_miles(n)
    n.to_s =~ /([^\.]*)(\..*)?/
    int, dec = $1.reverse, $2 ? $2 : ""
    while int.gsub!(/(,|\.|^)(\d{3})(\d)/, '\1\2,\3')
    end
    int.reverse + dec.ljust(2,'0')
  end


  def round(float, num_of_decimal_places=1)
      exponent = num_of_decimal_places + 2
      @float = float*(10**exponent)
      @float = @float.round
      @float = @float / (10.0**exponent)
  end


  def tiene_permiso?(rol, controlador)
    @controlador = Controller.find(controlador)
    @registro = Systable.find(:first, :conditions => ["rol_id = ? and controller_id = ? ", Rol.find(rol).id, @controlador.id])
    return ( @registro.nil? ) ? false : true
  end


  def procesar_archivo_texto(name)
      num = clave = 0
      num_linea = 1
      File.open("#{RAILS_ROOT}/public/tmp/#{name}").each do |linea|
        if num_linea == 1
            num, clave = linea.split("/")
            return false unless clave =~ /^[A-Z]{4}/
        end
        num_linea+=1
      end
  end


  #-------- Funciones para la manipulacion del layout (archivo de texto) ----

  def encabezado_valido?(filename)
      num = clave = 0
      num_linea = 1
      File.open("#{RAILS_ROOT}/public/tmp/#{filename}").each do |linea|
        if num_linea == 1
            num, clave = linea.split("/")
            return false unless clave =~ /^[A-Z]{4}/
            return false unless num =~/\d{4}/
        #--- Validamos que no este repetido la clave y numero -----
            return false if Datafile.find(:all, :conditions => ["clave = ? and numero = ?", clave.strip, num.strip]).size > 0
        end
        num_linea+=1
      end
      return true
   end




    def inserta_metadatos(name, datafile)
      num_linea = 1
      File.open("#{RAILS_ROOT}/public/tmp/#{name}").each do |linea|
        if num_linea == 1
            numero, clave = linea.split("/")
            if clave =~ /^[A-Z]{4}/
               datafile.clave = clave
            end
            if numero =~/\d{4}/
               datafile.numero = numero
            end
        end

       if num_linea == 5
          cadena = linea.split("|")
          fecha, hora_completa, datafile.numero_cliente, datafile.nombre_cliente, datafile.codigo,  datafile.sucursal, datafile.cuenta, datafile.nombre_cuenta, datafile.moneda, datafile.num_movimientos = cadena[0], cadena[1], cadena[2], cadena[3], cadena[4], cadena[6], cadena[7], cadena[8], cadena[9], cadena[10].to_i
          @dia, @mes, @anio = fecha.split("/")
          @hora, @minutos = hora_completa.split(":")
        end
        num_linea+=1
      end

        #--- Asignacion de metadatos
        datafile.fecha_hora_archivo = DateTime.new(@anio.to_i, @mes.to_i, @dia.to_i, @hora.to_i, @minutos.to_i).strftime("%Y-%m-%d %H:%M:%S")
        datafile.save
        return true
   end







  def tiene_permiso_accion?(rol, controlador,accion)
      @controlador = Controller.find(controlador)
      @registro = Systable.find(:first, :conditions => ["rol_id = ? and controller_id = ? and #{accion.upcase} = 1", Rol.find(rol).id, @controlador.id])
      return ( @registro.nil? ) ? false : true
  end


    def asigna_permisos(rol, controllers=nil, permisos_insertar=nil, permisos_actualizar=nil, permisos_eliminar=nil)
      rol = Rol.find(rol)
      if controllers
        controllers.each do |controller|
        #---- Validamos si ya lo tiene ----
          unless Systable.find(:first, :conditions =>["controller_id = ? and rol_id = ?", controller, rol.id ])
               Systable.create(:controller_id => controller, :rol_id => rol.id)
          end
         end
      else
          return false
      end
      #---- Insertamos los permisos de insertar ----
          if permisos_insertar
             permisos_insertar.each do |controller|
        #---- Validamos si ya lo tiene ----
               unless (x = Systable.find(:first, :conditions =>["controller_id = ? and rol_id = ?", controller, rol.id ])).nil?
                  x.insertar= 1
                  x.save!
               end
             end
          end
       #---- Insertamos los permisos de actualizar ----
        if permisos_actualizar
           permisos_actualizar.each do |controller|
           #---- Validamos si ya lo tiene ----
            unless (x= Systable.find(:first, :conditions =>["controller_id = ? and rol_id = ?", controller, rol.id ])).nil?
                x.actualizar= 1
                x.save!
            end
          end
        end
        #---- Insertamos los permisos de eliminar ----
        if permisos_eliminar
           permisos_eliminar.each do |controller|
          #---- Validamos si ya lo tiene ----
            unless (x= Systable.find(:first, :conditions =>["controller_id = ? and rol_id = ?", controller, rol.id ])).nil?
                x.eliminar= 1
                x.save!
            end
        end
        end
     return true
   end
   


  #--- Conversion de ISO a UTF-8 para los reportes ---
  def to_iso(texto)
      c = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
      iso = c.iconv(texto)
      return iso
  end


  def valida_referencia_alfa(num)
    if num.size < 29
      return false
    end
    sucursal = num[0..3]
    cuenta = num[4..10]
    ref_numerica = num[11..28]
    digito = num[29..30]
    #--- conversion de letras a numeros ----
    num.gsub!(/A|B|C/, '2')
    num.gsub!(/D|E|F/, '3')
    num.gsub!(/G|H|I/, '4')
    num.gsub!(/J|K|L/, '5')
    num.gsub!(/M|N|O/, '6')
    num.gsub!(/P|Q|R/, '7')
    num.gsub!(/S|T|U/, '8')
    num.gsub!(/V|W|X/, '9')
    num.gsub!(/Y|Z/, '0')
    #----- multiplicadores -----
    sumatoria = 0
    m = %w{23 29 31 37 13 17 19 23 29 31 37 19 23 29 31 37 1 2 3 5 7 11 13 17 19 23 29 31 37}
    contador = 0
    num.each_char do |char|
      sumatoria += char.to_i * m[contador].to_i
      contador+=1
    end

    ponderador = sumatoria%97
    dd = 99 - ponderador
  return num + dd.to_s
end



    def genera_referencia_alfa(sucursal, cuenta)
    if sucursal.to_s.size == 4 && cuenta.to_s.size == 7
      @configuracion = Configuracion.find(:first, :conditions => "activo = 1")
      prefijo = @configuracion.prefijo
      @configuracion.ultima_referencia += 1
      @configuracion.save!
      ultima_referencia = @configuracion.ultima_referencia.to_s.rjust(18, "0")
      #ref_numerica = prefijo + ultima_referencia
      num = sucursal.to_s + cuenta.to_s + ultima_referencia
      #---- Posiciones ------
      #sucursal = num[0..3]
      #cuenta = num[4..10]
      #ref_numerica = num[11..28]
      #digito = num[29..30]

      #--- conversion de letras a numeros ----
      num.gsub!(/A|B|C/, '2')
      num.gsub!(/D|E|F/, '3')
      num.gsub!(/G|H|I/, '4')
      num.gsub!(/J|K|L/, '5')
      num.gsub!(/M|N|O/, '6')
      num.gsub!(/P|Q|R/, '7')
      num.gsub!(/S|T|U/, '8')
      num.gsub!(/V|W|X/, '9')
      num.gsub!(/Y|Z/, '0')
      #----- multiplicadores -----
      sumatoria = 0
      m = %w{23 29 31 37 13 17 19 23 29 31 37 19 23 29 31 37 1 2 3 5 7 11 13 17 19 23 29 31 37}
      contador = 0
      num.each_char do |char|
        sumatoria += char.to_i * m[contador].to_i
        contador+=1
      end

      ponderador = sumatoria%97
      dd = 99 - ponderador
      return num + dd.to_s.rjust(2,"0")
    else
      return nil
    end
      
end


   #--- combo de semanas, maximo 52 ----
  @semanas = []
  (1..52).each do |x| @semanas << x end
  $semanas = @semanas

    def dias_mes(numero_mes)
      return (Date.new(Time.now.year,12,31)<<(12-numero_mes)).day.to_i
    end

end
