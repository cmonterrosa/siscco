class CreateConfiguracions < ActiveRecord::Migration
  def self.up
    create_table :configuracion do |t|
      t.column :nombre_empresa, :string
      t.column :direccion, :string
      t.column :telefono, :string
      t.column :activo, :string, :default => 1
      #---- campo para historial -----
      t.column :st, :integer
    end

    Configuracion.create(:tasa_interes=>"2.5",
                         :interes_moratorio=>"2.5",
                         :multa=>"0")

  end

  def self.down
    drop_table :configuracion
  end
end
