# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    #---- Funciones que pueden ser usadas desde cualquier vista ----
    def controllers_by_rol(rol)
    @rol = Rol.find(rol)
    return @rol.systables
  end

    def rol_tiene_permiso?(rol,controlador)
      @rol = Rol.find(rol)
      @controlador = Systable.find(controlador)
      if @rol.nil?
         false
      else
        @rol.systables.include?(@controlador)
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


  




end
