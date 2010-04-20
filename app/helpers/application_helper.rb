# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    #---- Funciones que pueden ser usadas desde cualquier vista ----
    def controllers_by_rol(rol)
    @rol = Rol.find(rol)
    return @rol.systables
  end

    def rol_tiene_permiso?(rol,controlador)
      @rol = Rol.find(rol)
      if @rol.nil?
        false
      else
        @rol.systables.include?(controlador)
      end
    end

       def todos_controladores
          Systable.find(:all, :select => ["distinct(controller), id, descripcion"])
       end


  




end
