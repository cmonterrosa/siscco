class CreateConfiguracions < ActiveRecord::Migration
  def self.up
    create_table :configuracion do |t|
      t.column :tasa_interes, :string
      t.column :interes_moratorio, :string
      t.column :multa, :string
    end

    Configuracion.create(:tasa_interes=>"2.5",
                         :interes_moratorio=>"2.5",
                         :multa=>"0")

  end

  def self.down
    drop_table :configuracion
  end
end