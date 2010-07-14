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
    @registro = Systable.find(:first, :conditions => ["rol_id = ? and controller_id = ? ", Rol.find(rol).id, @controlador])
    return ( @registro.nil? ) ? false : true
  end

end