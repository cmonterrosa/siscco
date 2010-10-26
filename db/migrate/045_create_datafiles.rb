class CreateDatafiles < ActiveRecord::Migration
  def self.up
    create_table :datafiles do |t|
      t.column :numero_cliente, :string, :limit => 4
      t.column :fecha_hora_archivo, :datetime
      t.column :fecha_hora_carga, :datetime
      t.column :sucursal, :string, :limit => 10
      t.column :cuenta, :string, :limit => 10
      t.column :nombre_archivo, :string
      t.column :num_movimientos, :integer
    end
  end

  def self.down
    drop_table :datafiles
  end
end
