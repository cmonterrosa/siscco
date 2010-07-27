module Utilerias

  def separar_miles(n)
    n.to_s =~ /([^\.]*)(\..*)?/
    int, dec = $1.reverse, $2 ? $2 : ""
    while int.gsub!(/(,|\.|^)(\d{3})(\d)/, '\1\2,\3')
    end
    int.reverse + dec.ljust(2,'0')
  end

  def tiene_permiso?(rol, controlador)
    @controlador = Controller.find(controlador)
    @registro = Systable.find(:first, :conditions => ["rol_id = ? and controller_id = ? ", Rol.find(rol).id, @controlador.id])
    return ( @registro.nil? ) ? false : true
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

 

   #--- combo de semanas, maximo 52 ----
  @semanas = []
  (1..52).each do |x| @semanas << x end
  $semanas = @semanas

end