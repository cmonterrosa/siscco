class CreateViviendas < ActiveRecord::Migration
  def self.up
    create_table :viviendas do |t|
      t.column :tipo_vivienda, :string
    end


  Vivienda.create(:tipo_vivienda => "BIOCASA O CASA")
  Vivienda.create(:tipo_vivienda => "DE ADOBE")
  Vivienda.create(:tipo_vivienda => "DE LADRILLO")
  Vivienda.create(:tipo_vivienda => "DE MADERA")
  Vivienda.create(:tipo_vivienda => "DE MATERIAL MIXTO")
  Vivienda.create(:tipo_vivienda => "DE PAJAS, RAMAS O CAÑAS")
  Vivienda.create(:tipo_vivienda => "DE PIEDRA")
  Vivienda.create(:tipo_vivienda => "APARTAMENTO")
  Vivienda.create(:tipo_vivienda => "DEPARTAMENTO")
  end

  def self.down
    drop_table :viviendas
  end
end
