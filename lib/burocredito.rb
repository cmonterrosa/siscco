require 'date'


class Buro
  attr_accessor :nombre_empresa, :string, :clave_usuario, :s_total
  
 def initialize(fecha=Time.now)
    #---- Datos del control -----
    @clientes_procesados=0
    @total_clientes = 0
    #--- Configuracion inicial ---
    $conf ||= Configuracion.find(:first, :conditions => "activo = 1")
    @nombre_empresa = $conf.nombre_empresa.upcase
    @direccion_empresa = $conf.direccion.upcase
    #--- Elementos del encabezado ---
    etiqueta="INTF"
    version="10"
    @clave_usuario = "ZZ99990001"
    numero_ciclo="00"
    uso_futuro="0000000000"
    #---- Formato de fecha ------
    dia, mes, anio = fecha.day, fecha.month, fecha.year
    dia.to_s.rjust(2,"0") + mes.to_s.rjust(2, "0") + anio.to_s.rjust(4, "0")
    fecha_reporte= dia.to_s.rjust(2,"0") + mes.to_s.rjust(2, "0") + anio.to_s.rjust(4, "0")
    @s_encabezado = etiqueta + version + @clave_usuario + @nombre_empresa + numero_ciclo + fecha_reporte + uso_futuro
    @s_total = @s_encabezado
    @s_pie = nil
  end


 def get_clientes
 return Cliente.find_by_sql("
 select
      c.id as credito,
      c.num_referencia as referencia,
      c.fecha_inicio as fecha_apertura_cuenta,
      c.monto as credito_maximo,
      g.id as grupo,
      cg.cliente_id as cliente,
      p.num_pagos as numero_pagos
  from
      creditos c, grupos g, clientes_grupos cg, productos p
  where
      c.grupo_id=g.id AND
      c.id = cg.grupo_id AND
      c.producto_id = p.id")

 end

 

  def calcular
    #----- Cifras de control ------
    total_saldos_actuales=0
    total_saldos_vencidos=0
    total_segmentos_intf = 1
    total_segmentos_nombre = 0
    total_segmentos_direccion = 0
    total_segmentos_empleo=0
    total_segmentos_cuentas = 0
    contador_bloques=0
    #-------------------- Ciclo principal --------------------
    clientes = get_clientes()
    @total_clientes = clientes.size
    clientes.each do |row|
          c = Cliente.find(row.cliente)
          #------- segmento de nombre ------
          e_paterno = "PN"
          if c.paterno.size < 1
            paterno = e_paterno + "NO PROPORCIONADO" + "16"
          else
            paterno = e_paterno +  tamanio(c.paterno) + c.paterno[0..25].upcase
          end
          e_materno = "00"
          if c.materno.size < 1
            materno = e_materno + "NO PROPORCIONADO" + "16"
          else
            materno = e_materno + tamanio(c.materno) + c.materno[0..25].upcase
          end
          e_nombre = "02"
          if c.nombre.size < 1
              nombre = e_nombre + "NO PROPORCIONADO" + "16"
          else
              nombre = e_nombre + tamanio(c.nombre)  + c.nombre[0..25].upcase
          end
          e_fecha_nac = "04"
          fecha_nacimiento = formato_fecha(c.fecha_nac)
          e_numero_rfc = "05"
          if c.rfc.size < 1
            numero_rfc = ""
          else
            numero_rfc = e_numero_rfc + tamanio(c.rfc) + c.rfc
          end

          e_clave_ife = "14"
          if c.clave_ife.size < 1
              clave_ife=""
          else
              clave_ife = e_clave_ife + tamanio(c.clave_ife) + c.clave_ife
          end
          total_segmentos_nombre+=1
          cadena_nombre =  paterno +  materno + nombre + e_fecha_nac + fecha_nacimiento + numero_rfc + clave_ife
          #------ termina segmento de nombre --------


          #----- Segmento de direccion -----
          e_direccion = "PA"
          if c.direccion.size < 1
              direccion=""
          else
              direccion = e_direccion + tamanio(c.direccion) + c.direccion.to_s.strip
          end

          e_colonia = "01"
          if c.colonia.size < 1
              colonia=""
          else
              colonia = e_colonia + tamanio(c.colonia) + c.colonia.strip
          end

          e_municipio = "02"
          unless c.localidad.municipio
            municipio=""
          else
            municipio = e_municipio + tamanio(c.localidad.municipio.municipio) +  c.localidad.municipio.municipio.strip
          end

          e_estado = "04"
          unless c.localidad.municipio.estado
            estado =""
          else
            estado = e_estado + tamanio(c.localidad.municipio.estado.edo_inegi) + c.localidad.municipio.estado.edo_inegi
          end

          e_codpostal = "05"
          if c.codigo_postal.size < 1
            codigo_postal =""
          else
            codigo_postal = e_codpostal + tamanio(c.codigo_postal) + c.codigo_postal
          end
          total_segmentos_direccion+=1
          cadena_direccion = direccion + colonia + municipio + estado + codigo_postal

          #------- Termina segmento de direccion -------
          
          #------- Segmento de empleo --------------- (nadamas direccion, municipio y estado ) --
          e_direccion_empleo = "00"
          if c.negocios[0].direccion.size < 1
            empleo_direccion =""
          else

          #---- Validacion del domicilio conocido ---
          c.negocios[0].direccion = "DOMICILIO CONOCIDO S/N" if c.negocios[0].direccion == "CONOCIDO"
          empleo_direccion = e_direccion_empleo + c.negocios[0].direccion.size.to_s + c.negocios[0].direccion.strip
          end
           e_municipio = "03"
          unless c.localidad.municipio
            empleo_municipio=""
          else
            empleo_municipio = e_municipio + tamanio(c.localidad.municipio.municipio) +  c.localidad.municipio.municipio.strip
          end
          e_estado_empleo = "05"
          unless c.localidad.municipio.estado
            empleo_estado =""
          else
            empleo_estado = e_estado_empleo + tamanio(c.localidad.municipio.estado.edo_inegi) + c.localidad.municipio.estado.edo_inegi
          end
          e_codpostal_empleo = "06"
          if c.codigo_postal.size < 1
            empleo_codigo_postal =""
          else
            empleo_codigo_postal = e_codpostal_empleo + tamanio(c.codigo_postal) + c.codigo_postal
          end
          cadena_empleo = empleo_direccion + empleo_municipio + empleo_estado + empleo_codigo_postal
          total_segmentos_empleo+=1
          #--- termina segmento de empleo ------

          #------- Segmento de cuentas ------
          e_segmento ="TL"
          e_member_code = "01"
          e_nombre_usuario = "02"
          nombre_usuario = e_nombre_usuario + tamanio(@nombre_empresa) + @nombre_empresa

          e_numero_cuenta = "04"

          if row.referencia.size < 1
             numero_cuenta_actual = ""
          else
             numero_cuenta_actual = e_numero_cuenta + tamanio(row.referencia) + row.referencia.to_s
          end

          e_tipo_cuenta = "06"
          tipo_cuenta = e_numero_cuenta + "01" + "I"

          e_tipo_contrato = "07"
          tipo_contrato = e_tipo_contrato + "02" + "CS"

          e_clave_unidad_monetaria = "08"
          clave_unidad_monetaria = e_clave_unidad_monetaria + "02" + "MX"

          e_numero_pagos= "10"
          numero_pagos = e_numero_pagos + tamanio(row.numero_pagos) + row.numero_pagos.to_s


          #----- Calculamos el vencimiento al dia de hoy -----
          vencimiento = Vencimiento.new(Credito.find(row.credito))
          vencimiento.procesar

          #---- Monto a pagar ---
          e_monto_a_pagar = "12"
          monto_a_pagar = e_monto_a_pagar + tamanio(vencimiento.total_deuda_individual.to_i) + vencimiento.total_deuda_individual.to_i.to_s
          total_saldos_vencidos+=vencimiento.total_deuda_individual.to_i
          total_saldos_actuales +=vencimiento.total_deuda_individual.to_i
          
          #-- Fecha de apertura de la cuenta ---
          e_fecha_apertura_cuenta = "13"
          unless row.fecha_apertura_cuenta
             fecha_apertura_cuenta = ""
          else
             fecha_apertura_cuenta = e_fecha_apertura_cuenta + "08" + formato_fecha_string(row.fecha_apertura_cuenta)
          end

          #--- fecha de ultima compra ----
          e_fecha_ultima_compra = "15"
          fecha_ultima_compra = e_fecha_ultima_compra + "08" + formato_fecha_string(row.fecha_apertura_cuenta)


          #---- credito maximo ------
          e_credito_maximo = "21"
          credito_maximo = e_credito_maximo + tamanio(row.credito_maximo) + row.credito_maximo
          
          #--- forma de pago actual -------
          e_forma_pago = "26"
          forma_pago = e_forma_pago + tamanio(vencimiento.dias_atraso) + calculo_forma_pago(vencimiento.dias_atraso)

          fin_segmento = "END"
          total_segmentos_cuentas+=1
          #--- fin de segmento  de cuentas -----
          cadena_cuentas = e_segmento + e_member_code + nombre_usuario + numero_cuenta_actual + tipo_cuenta + tipo_contrato + clave_unidad_monetaria + numero_pagos  + monto_a_pagar + fecha_apertura_cuenta + fecha_ultima_compra + credito_maximo + forma_pago + fin_segmento
          @s_total << cadena_nombre + cadena_direccion + cadena_empleo + cadena_cuentas
          @clientes_procesados+=1
          #puts("Total de clientes : #{@total_clientes }")
          #puts("Clientes procesados : #{@clientes_procesados }")
          print("\rProcesado: #{((@clientes_procesados / @total_clientes.to_f) * 100.0).truncate }  %")
          
    end
    #------ Segmento de cifras de control ------
    etiqueta_segmento ="TRL"
    @s_pie = etiqueta_segmento + total_saldos_vencidos.to_s.rjust(14, "0") + total_saldos_actuales.to_s.rjust(14, "0") + total_segmentos_intf.to_s.rjust(3,"0") + total_segmentos_nombre.to_s.rjust(9,"0") + total_segmentos_direccion.to_s.rjust(9,"0") + total_segmentos_empleo.to_s.rjust(9,"0") + total_segmentos_cuentas.to_s.rjust(9,"0") + contador_bloques.to_s.rjust(6, "0") + @nombre_empresa.rjust(16, " ") + @direccion_empresa.rjust(160, " ")
    @s_total << @s_pie
  end
  


   def imprimir
    puts @s_total
  end




#--- Funciones de apoyo ----
protected
  def formato_fecha(fecha=Time.now)
      dia, mes, anio = fecha.day, fecha.month, fecha.year
      return dia.to_s.rjust(2,"0") + mes.to_s.rjust(2, "0") + anio.to_s.rjust(4, "0")
  end

  def formato_fecha_string(string)
    anio,mes,dia = string.split("-")
    return formato_fecha(DateTime.new(anio.to_i, mes.to_i, dia.to_i))
  end

  def tamanio(string)
     string.to_s.size.to_s.rjust(2,"0")
  end


  def calculo_forma_pago(dias_atraso)
   ######################
   #UR => Cuenta sin informacion
   #00 => Muy reciente para ser informada
   #01 => Cuenta al corriente
   #02 => de 1 a 29 dias
   case dias_atraso
    when 0
      return "01"
    when 1..29
      return "02"
    when 30..59
      return "03"
    when 60..89
      return "04"
    when 90..119
       return "05"
    when 120..149
       return "06"
    when 150..364
       return "07"
    when 365
       return "96"
    else
      return "UR"
   end
  end


end




