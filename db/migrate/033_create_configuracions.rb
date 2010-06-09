class CreateConfiguracions < ActiveRecord::Migration
  def self.up
    create_table :configuracion do |t|
      t.column :tasa_interes, :string
      t.column :interes_moratorio, :string
      t.column :multa, :string
    end
  end

  def self.down
    drop_table :configuracion
  end
end
