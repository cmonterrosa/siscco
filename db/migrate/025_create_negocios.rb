class CreateNegocios < ActiveRecord::Migration
  def self.up
    create_table :negocios do |t|
      t.column :nombre, :string
      t.column :puesto, :string
      t.column :direccion, :string
      t.column :telefono, :string, :limit => 10
      t.column :num_empleados, :integer
      t.column :cliente_id, :integer
      t.column :giro_id, :integer
    end
  end

  def self.down
    drop_table :negocios
  end
end
