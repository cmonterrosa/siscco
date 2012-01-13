  module Variables
  #----------Variables para combos globales -----------
  $estados = Estado.find(:all, :order => "estado")
  $ejidos ||= Ejido.find(:all, :order => "ejido")
  $colonias ||= Colonia.find(:all, :order => "colonia")
  $municipios ||= Municipio.find(:all, :order => "municipio")
  $bancos = Banco.find(:all)
  $ctaconcentradoras = Ctaconcentradora.find(:all)
  $ctaliquidadoras = Ctaliquidadora.find(:all)
  $ejidos ||= Ejido.find(:all)
  $localidades ||= Localidad.find_by_sql("select * from localidads order by localidad")
  $periodos ||= Periodo.find(:all, :order => "dias")
  #$productos = Producto.find(:all, :order => "producto")
  $users = User.find(:all, :order => "login")
  $civiles ||= Civil.find(:all)
  $escolaridades ||= Escolaridad.find(:all)
  $viviendas ||= Vivienda.find(:all)
  $tipos_interes ||= ["SALDOS INSOLUTOS (SSI)", "GLOBAL MENSUAL (FLAT)"]
  $cuentas = Cuenta.find(:all)
  $rol ||= RolHogar.find(:all)
  $destino ||= Destino.find(:all)
  $ubicacion ||= UbicacionNegocio.find(:all)
  $nacionalidades ||= Nacionalidad.find_by_sql("select * from nacionalidads")

  #----------- Cambio de idioma de las fechas --------------------
  Date::MONTHNAMES = [nil] + %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
  Date::DAYNAMES = %w(Domingo Lunes Martes Miercoles Jueves Viernes Sábado)
  Date::ABBR_MONTHNAMES = [nil] + %w(ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic)
  Date::ABBR_DAYNAMES = %w(Dom Lun Mar Mie Jue Vie Sab)

  #------ Configuracion -----
  $conf ||= Configuracion.find(:first, :conditions => "activo = 1")
  CIUDAD_EMPRESA = $conf.ciudad
  NOMBRE_EMPRESA = $conf.nombre_empresa
  DIRECCION_EMPRESA = $conf.direccion
  TELEFONO_EMPRESA = $conf.telefono
  SUCURSAL = "SOCAMA CENTRO FRAYLESCA A.C"
end
