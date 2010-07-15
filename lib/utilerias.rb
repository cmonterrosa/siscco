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
        unless Systable.find(:first, :conditions =>["controller_id = ? and rol_id = ?", controller.id, rol.id ])
             Systable.create(:controller_id => controller.id, :rol_id => rol.id)
        end
      end
    else
      return false
    end
     #---- Insertamos los permisos de insertar ----
     if permisos_insertar
        Systable.find(:first, :conditions =>["controller_id = ? and rol_id = ?", controller.id, rol.id).each do |permiso_insertar|
          permiso_insertar.insertar = 1
          permiso_insertar.save!
        end
     end

     #---- Insertamos los permisos de actualizar ----
     if permisos_actualizar
        Systable.find(permisos_actualizar).each do |permiso_actualizar|
          permiso_actualizar.insertar = 1
          permiso_actualizar.save!
        end
     end
     #---- Insertamos los permisos de eliminar ----
     if permisos_eliminar
        Systable.find(permisos_eliminar).each do |permiso_eliminar|
          permiso_eliminar.insertar = 1
          permiso_eliminar.save!
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

   #--- combo de semanas, maximo 52 ----
  @semanas = []
  (1..52).each do |x| @semanas << x end
  $semanas = @semanas

end