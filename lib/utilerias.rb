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

   #--- combo de semanas, maximo 52 ----
  @semanas = []
  (1..52).each do |x| @semanas << x end
  $semanas = @semanas

end