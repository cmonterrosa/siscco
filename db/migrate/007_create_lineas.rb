class CreateLineas < ActiveRecord::Migration
  def self.up
    create_table :lineas do |t|
      t.column :fondeo_id, :integer
      t.column :cuenta_cheques, :string
      t.column :fecha_autorizacion, :date
      t.column :linea_autorizada, :string
      t.column :estatus, :string
      t.column :gcnf, :string
    end
  end

  def self.down
    drop_table :lineas
  end
end
