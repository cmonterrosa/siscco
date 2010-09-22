class CreateConfiguracions < ActiveRecord::Migration
  def self.up
    create_table :configuracion do |t|
      t.column :nombre_empresa, :string
      t.column :direccion, :string
      t.column :ciudad, :string
      t.column :prefijo, :string
      t.column :telefono, :string
      t.column :activo, :string, :default => 1
      t.column :ultima_referencia, :integer
    end

   Configuracion.create(:nombre_empresa => "SOCAMA FRAYLESCA S.A DE C.V",
                       :ciudad => "Tuxtla Gutiérrez, Chiapas",
                       :direccion => "13a Avenida Sur Poniente Número 640, Barrio San Francisco",
                       :telefono => "9616112840",
                       :prefijo => "SOC",
                       :ultima_referencia => 0)
   end

  def self.down
    drop_table :configuracion
  end
end
