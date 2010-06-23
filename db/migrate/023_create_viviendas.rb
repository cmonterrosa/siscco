class CreateViviendas < ActiveRecord::Migration
  def self.up
    create_table :viviendas do |t|
      t.column :tipo_vivienda, :string
    end


  Vivienda.create("BIOCASA O CASA")
  Vivienda.create("DE ADOBE")
  Vivienda.create("DE LADRILLO")
  Vivienda.create("DE MADERA")
  Vivienda.create("DE MATERIAL MIXTO")
  Vivienda.create("DE PAJAS, RAMAS O CAÑAS")
  Vivienda.create("DE PIEDRA")
  Vivienda.create("APARTAMENTO")
  Vivienda.create("DEPARTAMENTO")
  end

  def self.down
    drop_table :viviendas
  end
end
