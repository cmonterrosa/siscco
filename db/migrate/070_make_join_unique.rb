class MakeJoinUnique < ActiveRecord::Migration
  def self.up
    ##--- Tabla clientes ---
    execute "ALTER TABLE clientes ADD CONSTRAINT civils_cliente FOREIGN KEY (civil_id) REFERENCES civils(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE clientes ADD CONSTRAINT escolaridads_cliente FOREIGN KEY (escolaridad_id) REFERENCES escolaridads(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE clientes ADD CONSTRAINT viviendas_cliente FOREIGN KEY (vivienda_id) REFERENCES viviendas(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE clientes ADD CONSTRAINT localidads_cliente FOREIGN KEY (localidad_id) REFERENCES localidads(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

            ##- - Preguntar -
            #    execute "ALTER TABLE clientes ADD CONSTRAINT edo_residencias_cliente FOREIGN KEY (edo_residencia_id) REFERENCES edo_residencias(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

    execute "ALTER TABLE clientes ADD CONSTRAINT nacionalidads_cliente FOREIGN KEY (nacionalidad_id) REFERENCES nacionalidads(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE clientes ADD CONSTRAINT rol_hogars_cliente FOREIGN KEY (rol_hogar_id) REFERENCES rol_hogars(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

            ##--- Tabla Bancos no existe ---
            #    execute "ALTER TABLE bancos ADD CONSTRAINT municipios_banco FOREIGN KEY (municipio_id) REFERENCES municipios(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

    #--- Tabla clientes_grupos ---
    execute "ALTER TABLE clientes_grupos ADD CONSTRAINT clientes_clientes_grupo FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE clientes_grupos ADD CONSTRAINT grupos_clientes_grupo FOREIGN KEY (grupo_id) REFERENCES grupos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    #--- Tabla Colonia ---
    execute "ALTER TABLE colonias ADD CONSTRAINT ejidos_colonia FOREIGN KEY (ejido_id) REFERENCES ejidos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    #--- Tabla Credito ---
    execute "ALTER TABLE creditos ADD CONSTRAINT clientes_credito FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

            ##--- No existe -----
            #    execute "ALTER TABLE creditos ADD CONSTRAINT periodos_credito FOREIGN KEY (periodo_id) REFERENCES periodos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

    execute "ALTER TABLE creditos ADD CONSTRAINT productos_credito FOREIGN KEY (producto_id) REFERENCES productos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE creditos ADD CONSTRAINT promotors_credito FOREIGN KEY (promotor_id) REFERENCES promotors(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE creditos ADD CONSTRAINT grupos_credito FOREIGN KEY (grupo_id) REFERENCES grupos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE creditos ADD CONSTRAINT lineas_credito FOREIGN KEY (linea_id) REFERENCES lineas(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE creditos ADD CONSTRAINT destinos_credito FOREIGN KEY (destino_id) REFERENCES destinos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Tabla ctaconcentradoras ---
    execute "ALTER TABLE ctaconcentradoras ADD CONSTRAINT sucbancarias_ctaconcentradora FOREIGN KEY (sucbancaria_id) REFERENCES sucbancarias(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE ctaconcentradoras ADD CONSTRAINT cuentas_ctaconcentradora FOREIGN KEY (cuenta_id) REFERENCES cuentas(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Tabla ctaliquidadora ---
    execute "ALTER TABLE ctaliquidadoras ADD CONSTRAINT sucbancarias_ctaliquidadora FOREIGN KEY (sucbancaria_id) REFERENCES sucbancarias(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE ctaliquidadoras ADD CONSTRAINT cuentas_ctaliquidadora FOREIGN KEY (cuenta_id) REFERENCES cuentas(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Deposito ---
    execute "ALTER TABLE depositos ADD CONSTRAINT datafiles_deposito FOREIGN KEY (datafile_id) REFERENCES datafiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE depositos ADD CONSTRAINT creditos_deposito FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Devengo ---
    execute "ALTER TABLE devengos ADD CONSTRAINT creditos_devengo FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Ejido ---
    execute "ALTER TABLE ejidos ADD CONSTRAINT municipios_ejido FOREIGN KEY (municipio_id) REFERENCES municipios(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Excedente ---
    execute "ALTER TABLE excedentes ADD CONSTRAINT creditos_excedente FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Extraordinario ---
    execute "ALTER TABLE extraordinarios ADD CONSTRAINT creditos_extraordinario FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Fechavalor ---
    execute "ALTER TABLE fechavalors ADD CONSTRAINT datafiles_fechavalor FOREIGN KEY (datafile_id) REFERENCES datafiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE fechavalors ADD CONSTRAINT creditos_fechavalor FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Linea ---
    execute "ALTER TABLE lineas ADD CONSTRAINT ctaliquidadoras_linea FOREIGN KEY (ctaliquidadora_id) REFERENCES ctaliquidadoras(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE lineas ADD CONSTRAINT ctaconcentradoras_linea FOREIGN KEY (ctaconcentradora_id) REFERENCES ctaconcentradoras(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE lineas ADD CONSTRAINT fondeos_linea FOREIGN KEY (fondeo_id) REFERENCES fondeos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Localidad ---
    execute "ALTER TABLE localidads ADD CONSTRAINT municipios_localidad FOREIGN KEY (municipio_id) REFERENCES municipios(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Miembro ---
    execute "ALTER TABLE miembros ADD CONSTRAINT jerarquias_miembro FOREIGN KEY (jerarquia_id) REFERENCES jerarquias(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE miembros ADD CONSTRAINT creditos_miembro FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE miembros ADD CONSTRAINT clientes_miembro FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Movimiento ---

          ##--- No existe ----
          # execute "ALTER TABLE movimientos ADD CONSTRAINT creditos_movimiento FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

    execute "ALTER TABLE movimientos ADD CONSTRAINT pagos_movimiento FOREIGN KEY (pago_id) REFERENCES pagos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Municipio ---
    execute "ALTER TABLE municipios ADD CONSTRAINT estados_municipio FOREIGN KEY (estado_id) REFERENCES estados(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Negocio ---
    execute "ALTER TABLE negocios ADD CONSTRAINT clientes_negocio FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE negocios ADD CONSTRAINT actividads_negocio FOREIGN KEY (actividad_id) REFERENCES actividads(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE negocios ADD CONSTRAINT ubicacion_negocios_negocio FOREIGN KEY (ubicacion_negocio_id) REFERENCES ubicacion_negocios(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Pago ---
    execute "ALTER TABLE pagos ADD CONSTRAINT creditos_pago FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE pagos ADD CONSTRAINT clientes_pago FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Pagoextraordinario ---
    execute "ALTER TABLE pagoextraordinarios ADD CONSTRAINT extraordinarios_pagoextraordinario FOREIGN KEY (extraordinario_id) REFERENCES extraordinarios(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Pagogrupal ---
    execute "ALTER TABLE pagogrupals ADD CONSTRAINT creditos_pagogrupal FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Pagoslinea ---
    execute "ALTER TABLE pagoslineas ADD CONSTRAINT lineas_pagoslinea FOREIGN KEY (linea_id) REFERENCES lineas(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Poliza ---
    execute "ALTER TABLE polizas ADD CONSTRAINT cuentas_poliza FOREIGN KEY (cuenta_id) REFERENCES cuentas(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Producto ---

          ##--- No existe ----
          # execute "ALTER TABLE productos ADD CONSTRAINT grupos_producto FOREIGN KEY (grupo_id) REFERENCES grupos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

    execute "ALTER TABLE productos ADD CONSTRAINT periodos_producto FOREIGN KEY (periodo_id) REFERENCES periodos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Promotor ---
    execute "ALTER TABLE promotors ADD CONSTRAINT sucursals_promotor FOREIGN KEY (sucursal_id) REFERENCES sucursals(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Referencia ---
    execute "ALTER TABLE referencias ADD CONSTRAINT creditos_referencia FOREIGN KEY (credito_id) REFERENCES creditos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Subsector ---
    execute "ALTER TABLE subsectors ADD CONSTRAINT sectors_subsector FOREIGN KEY (sector_id) REFERENCES sectors(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Sucbancaria ---
    execute "ALTER TABLE sucbancarias ADD CONSTRAINT bancos_sucbancaria FOREIGN KEY (banco_id) REFERENCES bancos(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Sucursal ---
    execute "ALTER TABLE sucursals ADD CONSTRAINT municipios_sucursal FOREIGN KEY (municipio_id) REFERENCES municipios(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Systable ---
    #execute "ALTER TABLE systables ADD CONSTRAINT rols_systable FOREIGN KEY (rol_id) REFERENCES rols(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    #execute "ALTER TABLE systables ADD CONSTRAINT controllers_systable FOREIGN KEY (controller_id) REFERENCES controllers(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##---Transaccion ---
    execute "ALTER TABLE transaccions ADD CONSTRAINT pagogrupals_transaccion FOREIGN KEY (pagogrupal_id) REFERENCES pagogrupals(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE transaccions ADD CONSTRAINT tipo_transaccions_transaccion FOREIGN KEY (tipo_transaccion_id) REFERENCES tipo_transaccions(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    execute "ALTER TABLE transaccions ADD CONSTRAINT datafiles_transaccion FOREIGN KEY (datafile_id) REFERENCES datafiles(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- Transferencia ---
    execute "ALTER TABLE transferencias ADD CONSTRAINT users_transferencia FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT;"
    ##--- User ---
    #execute "ALTER TABLE users ADD CONSTRAINT rols_user FOREIGN KEY (rol_id) REFERENCES rols(id) ON UPDATE CASCADE ON DELETE RESTRICT;"

  end

  def self.down
    ##--- Tabla clientes ---
    execute "ALTER TABLE clientes DROP FOREIGN KEY civils_cliente;"
    execute "ALTER TABLE clientes DROP FOREIGN KEY escolaridads_cliente;"
    execute "ALTER TABLE clientes DROP FOREIGN KEY viviendas_cliente;"
    execute "ALTER TABLE clientes DROP FOREIGN KEY localidads_cliente;"

          ##- - Preguntar -
          #    execute "ALTER TABLE clientes DROP FOREIGN KEY edo_residencia_cliente;"

    execute "ALTER TABLE clientes DROP FOREIGN KEY nacionalidads_cliente;"
    execute "ALTER TABLE clientes DROP FOREIGN KEY rol_hogars_cliente;"

          ##--- Tabla Bancos no existe ---
          #   execute "ALTER TABLE bancos DROP FOREIGN KEY municipios_banco;"

    execute "ALTER TABLE clientes_grupos DROP FOREIGN KEY clientes_clientes_grupo;"
    execute "ALTER TABLE clientes_grupos DROP FOREIGN KEY grupos_clientes_grupo;"
    ##--- Tabla Colonia ---
    execute "ALTER TABLE colonias DROP FOREIGN KEY ejidos_colonia;"
    ##--- Tabla Credito ---
    execute "ALTER TABLE creditos DROP FOREIGN KEY clientes_credito;"

          ##---- No existe ----
          #    execute "ALTER TABLE creditos DROP FOREIGN KEY periodos_credito;"

    execute "ALTER TABLE creditos DROP FOREIGN KEY productos_credito;"
    execute "ALTER TABLE creditos DROP FOREIGN KEY promotors_credito;"
    execute "ALTER TABLE creditos DROP FOREIGN KEY grupos_credito;"
    execute "ALTER TABLE creditos DROP FOREIGN KEY lineas_credito;"
    execute "ALTER TABLE creditos DROP FOREIGN KEY destinos_credito;"
    ##--- Tabla ctaconcentradoras ---
    execute "ALTER TABLE ctaconcentradoras DROP FOREIGN KEY sucbancarias_ctaconcentradora;"
    execute "ALTER TABLE ctaconcentradoras DROP FOREIGN KEY cuentas_ctaconcentradora;"
    ##--- Tabla ctaliquidadora ---
    execute "ALTER TABLE ctaliquidadoras DROP FOREIGN KEY sucbancarias_ctaliquidadora;"
    execute "ALTER TABLE ctaliquidadoras DROP FOREIGN KEY cuentas_ctaliquidadora;"
    ##--- Deposito ---
    execute "ALTER TABLE depositos DROP FOREIGN KEY datafiles_deposito;"
    execute "ALTER TABLE depositos DROP FOREIGN KEY creditos_deposito;"
    ##--- Devengo ---
    execute "ALTER TABLE devengos DROP FOREIGN KEY creditos_devengo;"
    ##--- Ejido ---
    execute "ALTER TABLE ejidos DROP FOREIGN KEY municipios_ejido;"
    ##--- Excedente ---
    execute "ALTER TABLE excedentes DROP FOREIGN KEY creditos_excedente;"
    ##--- Extraordinario ---
    execute "ALTER TABLE extraordinarios DROP FOREIGN KEY creditos_extraordinario;"
    ##--- Fechavalor ---
    execute "ALTER TABLE fechavalors DROP FOREIGN KEY datafiles_fechavalor;"
    execute "ALTER TABLE fechavalors DROP FOREIGN KEY creditos_fechavalor;"
    ##--- Linea ---
    execute "ALTER TABLE lineas DROP FOREIGN KEY ctaliquidadoras_linea;"
    execute "ALTER TABLE lineas DROP FOREIGN KEY ctaconcentradoras_linea;"
    execute "ALTER TABLE lineas DROP FOREIGN KEY fondeos_linea;"
    ##--- Localidad ---
    execute "ALTER TABLE localidads DROP FOREIGN KEY municipios_localidad;"
    ##--- Miembro ---
    execute "ALTER TABLE miembros DROP FOREIGN KEY jerarquias_miembro;"
    execute "ALTER TABLE miembros DROP FOREIGN KEY creditos_miembro;"
    execute "ALTER TABLE miembros DROP FOREIGN KEY clientes_miembro;"
    ##--- Movimiento ---

          ##--- No existe ---
          # execute "ALTER TABLE movimientos DROP FOREIGN KEY creditos_movimiento;"
          
    execute "ALTER TABLE movimientos DROP FOREIGN KEY pagos_movimiento;"
    ##--- Municipio ---
    execute "ALTER TABLE municipios DROP FOREIGN KEY estados_municipio;"
    ##--- Negocio ---
    execute "ALTER TABLE negocios DROP FOREIGN KEY clientes_negocio;"
    execute "ALTER TABLE negocios DROP FOREIGN KEY actividads_negocio;"
    execute "ALTER TABLE negocios DROP FOREIGN KEY ubicacion_negocios_negocio;"
    ##--- Pago ---
    execute "ALTER TABLE pagos DROP FOREIGN KEY creditos_pago;"
    execute "ALTER TABLE pagos DROP FOREIGN KEY clientes_pago;"
    ##--- Pagoextraordinario ---
    execute "ALTER TABLE pagoextraordinarios DROP FOREIGN KEY extraordinarios_pagoextraordinario;"
    ##--- Pagogrupal ---
    execute "ALTER TABLE pagogrupals DROP FOREIGN KEY creditos_pagogrupal;"
    ##--- Pagoslinea ---
    execute "ALTER TABLE pagoslineas DROP FOREIGN KEY lineas_pagoslinea;"
    ##--- Poliza ---
    execute "ALTER TABLE polizas DROP FOREIGN KEY cuentas_poliza;"
    ##--- Producto ---

          ##--- No existe ---
          # execute "ALTER TABLE productos DROP FOREIGN KEY grupos_producto;"

    execute "ALTER TABLE productos DROP FOREIGN KEY periodos_producto;"
    ##--- Promotor ---
    execute "ALTER TABLE promotors DROP FOREIGN KEY sucursals_promotor;"
    ##--- Referencia ---
    execute "ALTER TABLE referencias DROP FOREIGN KEY creditos_referencia;"
    ##--- Subsector ---
    execute "ALTER TABLE subsectors DROP FOREIGN KEY sectors_subsector;"
    ##--- Sucbancaria ---
    execute "ALTER TABLE sucbancarias DROP FOREIGN KEY bancos_sucbancaria;"
    ##--- Sucursal ---
    execute "ALTER TABLE sucursals DROP FOREIGN KEY municipios_sucursal;"
    ##--- Systable ---
    #execute "ALTER TABLE systables DROP FOREIGN KEY rols_systable;"
    #execute "ALTER TABLE systables DROP FOREIGN KEY controllers_systable;"
    ##---Transaccion ---
    execute "ALTER TABLE transaccions DROP FOREIGN KEY pagogrupals_transaccion;"
    execute "ALTER TABLE transaccions DROP FOREIGN KEY tipo_transaccions_transaccion;"
    execute "ALTER TABLE transaccions DROP FOREIGN KEY datafiles_transaccion;"
    ##--- Transferencia ---
    execute "ALTER TABLE transferencias DROP FOREIGN KEY users_transferencia;"
    ##--- User ---
    #execute "ALTER TABLE users DROP FOREIGN KEY rols_user;"

  end
end
