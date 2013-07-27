# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130704182608) do

  create_table "actividads", :force => true do |t|
    t.string "clave_inegi"
    t.string "actividad"
  end

  create_table "ahorros", :force => true do |t|
    t.string   "monto"
    t.integer  "cliente_id"
    t.integer  "credito_id"
    t.datetime "hora_fecha"
  end

  create_table "bancos", :force => true do |t|
    t.string "nombre"
  end

  create_table "civils", :force => true do |t|
    t.string "civil"
  end

  create_table "clientes", :force => true do |t|
    t.string  "identificador",     :limit => 18
    t.string  "paterno"
    t.string  "materno"
    t.string  "nombre"
    t.date    "fecha_nac"
    t.string  "rfc",               :limit => 13
    t.string  "curp",              :limit => 18
    t.string  "clave_ife"
    t.string  "sexo",              :limit => 1
    t.string  "tipo_propiedad"
    t.string  "tipo_persona"
    t.string  "direccion"
    t.string  "colonia"
    t.string  "codigo_postal"
    t.string  "telefono",          :limit => 10
    t.string  "fax",               :limit => 10
    t.string  "email"
    t.string  "folio_rfc",         :limit => 13
    t.integer "civil_id"
    t.integer "escolaridad_id"
    t.integer "vivienda_id"
    t.integer "localidad_id"
    t.integer "nacionalidad_id"
    t.integer "rol_hogar_id"
    t.integer "edo_residencia_id"
    t.integer "st"
    t.string  "num_exterior",      :limit => 10
    t.string  "num_interior",      :limit => 10
    t.date    "fecha_captura"
  end

  add_index "clientes", ["civil_id"], :name => "civils_cliente"
  add_index "clientes", ["curp"], :name => "curp"
  add_index "clientes", ["escolaridad_id"], :name => "escolaridads_cliente"
  add_index "clientes", ["localidad_id"], :name => "localidads_cliente"
  add_index "clientes", ["nacionalidad_id"], :name => "nacionalidads_cliente"
  add_index "clientes", ["paterno", "materno", "nombre"], :name => "paterno_materno_nombre"
  add_index "clientes", ["rol_hogar_id"], :name => "rol_hogars_cliente"
  add_index "clientes", ["vivienda_id"], :name => "viviendas_cliente"

  create_table "clientes_grupos", :force => true do |t|
    t.integer  "cliente_id"
    t.integer  "grupo_id"
    t.integer  "activo"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
  end

  add_index "clientes_grupos", ["activo"], :name => "index_clientes_grupos_on_activo"
  add_index "clientes_grupos", ["cliente_id"], :name => "index_clientes_grupos_on_cliente_id"
  add_index "clientes_grupos", ["grupo_id"], :name => "index_clientes_grupos_on_grupo_id"

  create_table "colonias", :force => true do |t|
    t.string  "colonia"
    t.string  "clave_inegi"
    t.integer "ejido_id"
    t.integer "st"
  end

  add_index "colonias", ["ejido_id"], :name => "ejidos_colonia"

  create_table "configuracion", :force => true do |t|
    t.string  "nombre_empresa"
    t.string  "direccion"
    t.string  "ciudad"
    t.string  "prefijo"
    t.string  "telefono"
    t.string  "activo",            :default => "1"
    t.integer "ultima_referencia"
    t.integer "ultima_poliza"
  end

  create_table "controllers", :force => true do |t|
    t.string "controller"
    t.string "descripcion"
  end

  create_table "creditos", :force => true do |t|
    t.date     "fecha_inicio"
    t.date     "fecha_captura"
    t.date     "fecha_fin"
    t.string   "num_referencia"
    t.float    "monto"
    t.float    "tasa_interes"
    t.string   "interes_moratorio"
    t.string   "identificador"
    t.string   "tipo_interes"
    t.integer  "linea_id"
    t.integer  "cliente_id"
    t.integer  "promotor_id"
    t.integer  "destino_id"
    t.integer  "grupo_id"
    t.integer  "producto_id"
    t.integer  "status"
    t.string   "tipo_aplicacion"
    t.decimal  "monto_inicial",         :precision => 15, :scale => 10
    t.datetime "updated_at"
    t.datetime "created_at"
    t.datetime "fecha_liquidacion"
    t.decimal  "cat",                   :precision => 15, :scale => 2
    t.decimal  "cat_comision_apertura", :precision => 15, :scale => 2
    t.decimal  "interes_global",        :precision => 15, :scale => 2
    t.decimal  "iva_global",            :precision => 15, :scale => 2
  end

  add_index "creditos", ["cliente_id"], :name => "clientes_credito"
  add_index "creditos", ["destino_id"], :name => "destinos_credito"
  add_index "creditos", ["grupo_id"], :name => "grupos_credito"
  add_index "creditos", ["linea_id"], :name => "lineas_credito"
  add_index "creditos", ["producto_id"], :name => "productos_credito"
  add_index "creditos", ["promotor_id"], :name => "promotors_credito"

  create_table "ctaconcentradoras", :force => true do |t|
    t.string  "num_cta"
    t.integer "cuenta_id"
    t.integer "sucbancaria_id"
  end

  add_index "ctaconcentradoras", ["cuenta_id"], :name => "cuentas_ctaconcentradora"
  add_index "ctaconcentradoras", ["sucbancaria_id"], :name => "sucbancarias_ctaconcentradora"

  create_table "ctaliquidadoras", :force => true do |t|
    t.string  "num_cta"
    t.integer "cuenta_id"
    t.integer "sucbancaria_id"
  end

  add_index "ctaliquidadoras", ["cuenta_id"], :name => "cuentas_ctaliquidadora"
  add_index "ctaliquidadoras", ["sucbancaria_id"], :name => "sucbancarias_ctaliquidadora"

  create_table "cuentas", :force => true do |t|
    t.string "sCtaNum", :limit => 20
    t.string "sNombre", :limit => 50
  end

  create_table "datafiles", :force => true do |t|
    t.string   "clave",              :limit => 4
    t.string   "numero",             :limit => 4
    t.string   "numero_cliente",     :limit => 4
    t.string   "nombre_cliente",     :limit => 120
    t.string   "codigo",             :limit => 18
    t.datetime "fecha_hora_archivo"
    t.datetime "fecha_hora_carga"
    t.string   "sucursal",           :limit => 10
    t.string   "cuenta",             :limit => 10
    t.string   "nombre_cuenta",      :limit => 120
    t.string   "nombre_archivo"
    t.string   "moneda",             :limit => 50
    t.integer  "num_movimientos"
    t.string   "archivo_na"
    t.string   "archivo_errores"
    t.string   "cksum"
  end

  create_table "depositos", :force => true do |t|
    t.string   "sucursal",     :limit => 20
    t.string   "autorizacion", :limit => 20
    t.string   "codigo",       :limit => 20
    t.string   "subcodigo",    :limit => 20
    t.string   "ref_num",      :limit => 20
    t.string   "ref_alfa",     :limit => 20
    t.string   "importe",      :limit => 20
    t.string   "st",           :limit => 2
    t.datetime "fecha_hora"
    t.integer  "datafile_id"
    t.integer  "credito_id"
  end

  add_index "depositos", ["credito_id"], :name => "creditos_deposito"
  add_index "depositos", ["datafile_id"], :name => "datafiles_deposito"

  create_table "destinos", :force => true do |t|
    t.string "destino"
  end

  create_table "devengos", :force => true do |t|
    t.date    "fecha"
    t.integer "dia"
    t.integer "semana"
    t.string  "generacion_obligacion",   :limit => 18
    t.string  "vto_amortizacion",        :limit => 18
    t.string  "cuenta_contable_interes", :limit => 18
    t.integer "credito_id"
  end

  add_index "devengos", ["credito_id"], :name => "creditos_devengo"

  create_table "ejidos", :force => true do |t|
    t.string  "ejido"
    t.string  "clave_inegi"
    t.integer "municipio_id"
    t.integer "st"
  end

  add_index "ejidos", ["municipio_id"], :name => "municipios_ejido"

  create_table "escolaridads", :force => true do |t|
    t.string  "escolaridad"
    t.integer "estudios_id"
  end

  create_table "estados", :force => true do |t|
    t.string "estado"
    t.string "edo_inegi"
    t.string "edo_renapo"
  end

  create_table "excedentes", :force => true do |t|
    t.integer  "credito_id"
    t.decimal  "monto",          :precision => 15, :scale => 2
    t.datetime "fecha_deposito"
  end

  add_index "excedentes", ["credito_id"], :name => "creditos_excedente"

  create_table "extraordinarios", :force => true do |t|
    t.integer "credito_id"
    t.integer "status"
    t.decimal "interes",            :precision => 15, :scale => 10
    t.decimal "capital",            :precision => 15, :scale => 10
    t.decimal "proporcion_capital", :precision => 15, :scale => 10
    t.decimal "proporcion_interes", :precision => 15, :scale => 10
  end

  add_index "extraordinarios", ["credito_id"], :name => "creditos_extraordinario"

  create_table "fechavalors", :force => true do |t|
    t.date     "fecha"
    t.string   "sucursal",     :limit => 20
    t.string   "autorizacion", :limit => 20
    t.string   "codigo",       :limit => 20
    t.string   "subcodigo",    :limit => 20
    t.string   "ref_alfa",     :limit => 20
    t.decimal  "importe",                    :precision => 15, :scale => 2
    t.string   "st",           :limit => 2
    t.datetime "fecha_hora"
    t.integer  "datafile_id"
    t.integer  "credito_id"
    t.string   "tipo",         :limit => 20
  end

  add_index "fechavalors", ["credito_id"], :name => "creditos_fechavalor"
  add_index "fechavalors", ["datafile_id"], :name => "datafiles_fechavalor"

  create_table "festivos", :force => true do |t|
    t.date   "fecha"
    t.string "descripcion"
  end

  create_table "fondeos", :force => true do |t|
    t.string "acronimo"
    t.string "fuente"
    t.string "domicilio"
    t.string "telefono"
  end

  create_table "garantias", :force => true do |t|
    t.string "garantia"
  end

  create_table "garantias_referencias", :id => false, :force => true do |t|
    t.integer "referencia_id"
    t.integer "garantia_id"
  end

  create_table "giros", :force => true do |t|
    t.string "giro"
    t.string "codigo"
    t.string "subsector"
  end

  create_table "grupos", :force => true do |t|
    t.string "nombre"
    t.string "identificador", :limit => 7
  end

  create_table "jerarquias", :force => true do |t|
    t.string "jerarquia"
  end

  create_table "lineas", :force => true do |t|
    t.string  "cuenta_cheques"
    t.date    "fecha_aut"
    t.float   "autorizado"
    t.string  "estatus",             :limit => 4
    t.string  "gcnf"
    t.integer "fondeo_id"
    t.integer "ctaconcentradora_id"
    t.integer "ctaliquidadora_id"
  end

  add_index "lineas", ["ctaconcentradora_id"], :name => "ctaconcentradoras_linea"
  add_index "lineas", ["ctaliquidadora_id"], :name => "ctaliquidadoras_linea"
  add_index "lineas", ["fondeo_id"], :name => "fondeos_linea"

  create_table "localidads", :force => true do |t|
    t.string  "loc_id"
    t.integer "municipio_id"
    t.string  "localidad"
  end

  add_index "localidads", ["municipio_id"], :name => "municipios_localidad"

  create_table "logs", :force => true do |t|
    t.string   "operacion"
    t.datetime "fecha_hora"
    t.string   "clase"
    t.integer  "user_id"
    t.integer  "objeto_id"
  end

  create_table "miembros", :force => true do |t|
    t.integer "credito_id"
    t.integer "jerarquia_id"
    t.integer "cliente_id"
  end

  add_index "miembros", ["cliente_id"], :name => "clientes_miembro"
  add_index "miembros", ["credito_id"], :name => "creditos_miembro"
  add_index "miembros", ["jerarquia_id"], :name => "jerarquias_miembro"

  create_table "movimientos", :force => true do |t|
    t.string  "tipo"
    t.float   "capital"
    t.date    "fecha"
    t.float   "interes"
    t.string  "concepto"
    t.integer "pago_id"
  end

  add_index "movimientos", ["pago_id"], :name => "pagos_movimiento"

  create_table "municipios", :force => true do |t|
    t.string  "municipio"
    t.string  "clave_inegi"
    t.integer "estado_id"
  end

  add_index "municipios", ["estado_id"], :name => "estados_municipio"

  create_table "nacionalidads", :force => true do |t|
    t.string "pais_id"
    t.string "pais"
    t.string "pais_gent"
  end

  create_table "negocios", :force => true do |t|
    t.string  "nombre"
    t.string  "puesto"
    t.string  "direccion"
    t.string  "descripcion"
    t.string  "telefono",             :limit => 10
    t.integer "num_empleados"
    t.float   "ing_semanal"
    t.integer "cliente_id"
    t.integer "actividad_id"
    t.integer "ubicacion_negocio_id"
  end

  add_index "negocios", ["actividad_id"], :name => "actividads_negocio"
  add_index "negocios", ["cliente_id"], :name => "clientes_negocio"
  add_index "negocios", ["ubicacion_negocio_id"], :name => "ubicacion_negocios_negocio"

  create_table "pagoextraordinarios", :force => true do |t|
    t.integer "extraordinario_id"
    t.date    "fecha"
    t.decimal "cantidad",          :precision => 15, :scale => 10
  end

  add_index "pagoextraordinarios", ["extraordinario_id"], :name => "extraordinarios_pagoextraordinario"

  create_table "pagogrupals", :force => true do |t|
    t.date    "fecha_limite"
    t.decimal "capital_minimo",       :precision => 15, :scale => 2
    t.decimal "interes_minimo",       :precision => 15, :scale => 2
    t.integer "pagado"
    t.integer "credito_id"
    t.integer "num_pago"
    t.float   "saldo_inicial"
    t.float   "saldo_final"
    t.decimal "principal_recuperado", :precision => 15, :scale => 2
    t.decimal "iva",                  :precision => 15, :scale => 2
  end

  add_index "pagogrupals", ["credito_id"], :name => "creditos_pagogrupal"

  create_table "pagos", :force => true do |t|
    t.integer "num_pago"
    t.date    "fecha_limite"
    t.decimal "capital_minimo",       :precision => 15, :scale => 2
    t.decimal "interes_minimo",       :precision => 15, :scale => 2
    t.decimal "moratorio",            :precision => 15, :scale => 2
    t.integer "pagado"
    t.integer "credito_id"
    t.integer "cliente_id"
    t.string  "descripcion"
    t.float   "int_devengados"
    t.decimal "saldo_inicial",        :precision => 15, :scale => 2
    t.decimal "saldo_final",          :precision => 15, :scale => 2
    t.decimal "principal_recuperado", :precision => 15, :scale => 2
    t.integer "deposito_id"
    t.decimal "iva",                  :precision => 15, :scale => 2
  end

  add_index "pagos", ["cliente_id"], :name => "clientes_pago"
  add_index "pagos", ["credito_id"], :name => "creditos_pago"

  create_table "pagoslineas", :force => true do |t|
    t.integer "linea_id"
    t.date    "fecha"
    t.string  "monto"
    t.string  "observaciones"
    t.integer "st"
  end

  add_index "pagoslineas", ["linea_id"], :name => "lineas_pagoslinea"

  create_table "periodos", :force => true do |t|
    t.string  "nombre"
    t.integer "dias"
    t.integer "pagos_mes"
  end

  create_table "polizas", :force => true do |t|
    t.date    "fecha"
    t.string  "tipo_poliza",   :limit => 1
    t.string  "num_poliza",    :limit => 6
    t.integer "cuenta_id"
    t.string  "naturaleza",    :limit => 25
    t.string  "importe",       :limit => 18
    t.string  "descripcion",   :limit => 60
    t.string  "identificador", :limit => 3
  end

  add_index "polizas", ["cuenta_id"], :name => "cuentas_poliza"

  create_table "productos", :force => true do |t|
    t.string  "producto",                  :limit => 100
    t.float   "intereses"
    t.float   "moratorio_ssi"
    t.float   "ahorro"
    t.integer "num_pagos"
    t.string  "tasa_anualizada",           :limit => 10
    t.integer "periodo_id"
    t.float   "moratorio_flat"
    t.float   "tasa_mensual_flat"
    t.decimal "iva",                                      :precision => 8,  :scale => 2
    t.decimal "gastos_cobranza",                          :precision => 8,  :scale => 2
    t.decimal "gastos_judiciales",                        :precision => 8,  :scale => 2
    t.decimal "cat",                                      :precision => 15, :scale => 2
    t.decimal "tasa_mensual_ssg",                         :precision => 15, :scale => 2
    t.decimal "tasa_comision_apertura",                   :precision => 15, :scale => 2
    t.decimal "iva_comision_apertura",                    :precision => 15, :scale => 2
    t.decimal "tasa_anualizada_moratoria",                :precision => 15, :scale => 2
  end

  add_index "productos", ["periodo_id"], :name => "periodos_producto"

  create_table "promotors", :force => true do |t|
    t.string  "paterno"
    t.string  "materno"
    t.string  "nombre"
    t.string  "direccion"
    t.string  "telefono",      :limit => 10
    t.string  "celular",       :limit => 10
    t.string  "email"
    t.string  "observaciones"
    t.integer "sucursal_id"
    t.integer "st"
  end

  add_index "promotors", ["sucursal_id"], :name => "sucursals_promotor"

  create_table "referencias", :force => true do |t|
    t.string  "paterno"
    t.string  "materno"
    t.string  "nombre"
    t.string  "parentesco"
    t.string  "direccion"
    t.string  "telefono",   :limit => 10
    t.string  "tipo"
    t.integer "credito_id"
  end

  add_index "referencias", ["credito_id"], :name => "creditos_referencia"

  create_table "rol_hogars", :force => true do |t|
    t.string "rol"
    t.string "alias"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.string "descripcion", :limit => 40
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sectors", :force => true do |t|
    t.string "sector"
  end

  create_table "status", :force => true do |t|
    t.string "statu"
  end

  create_table "subsectors", :force => true do |t|
    t.string  "subsector"
    t.integer "sector_id"
  end

  add_index "subsectors", ["sector_id"], :name => "sectors_subsector"

  create_table "sucbancarias", :force => true do |t|
    t.string  "num_sucursal", :limit => 4
    t.string  "nombre"
    t.integer "banco_id"
  end

  add_index "sucbancarias", ["banco_id"], :name => "bancos_sucbancaria"

  create_table "sucursals", :force => true do |t|
    t.string  "nombre"
    t.string  "gerente"
    t.string  "telefono"
    t.string  "direccion"
    t.string  "codigo_postal"
    t.integer "municipio_id"
  end

  add_index "sucursals", ["municipio_id"], :name => "municipios_sucursal"

  create_table "tipo_transaccions", :force => true do |t|
    t.string  "descripcion"
    t.integer "prioridad"
  end

  create_table "transaccions", :force => true do |t|
    t.decimal  "monto",                 :precision => 15, :scale => 2
    t.integer  "pagogrupal_id"
    t.integer  "tipo_transaccion_id"
    t.datetime "fecha_hora_aplicacion"
    t.integer  "datafile_id"
  end

  add_index "transaccions", ["datafile_id"], :name => "datafiles_transaccion"
  add_index "transaccions", ["pagogrupal_id"], :name => "pagogrupals_transaccion"
  add_index "transaccions", ["tipo_transaccion_id"], :name => "tipo_transaccions_transaccion"

  create_table "transferencias", :force => true do |t|
    t.integer "origen_id"
    t.integer "destino_id"
    t.integer "user_id"
    t.date    "fecha"
    t.string  "monto"
    t.string  "observaciones"
    t.integer "st"
  end

  add_index "transferencias", ["user_id"], :name => "users_transferencia"

  create_table "ubicacion_negocios", :force => true do |t|
    t.string "ubicacion"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "paterno",                   :limit => 40
    t.string   "materno",                   :limit => 40
    t.string   "nombre",                    :limit => 60
    t.string   "direccion",                 :limit => 120
    t.string   "tel_celular",               :limit => 10
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "viviendas", :force => true do |t|
    t.string "tipo_vivienda"
  end

end
