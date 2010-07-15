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