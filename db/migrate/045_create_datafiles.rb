class CreateDatafiles < ActiveRecord::Migration
  def self.up
    create_table :datafiles do |t|
      #--- Identificacion del archivo ---
      t.column :clave, :string, :limit => 4
      t.column :numero, :string, :limit => 4
      #----------------------------------
      t.column :numero_cliente, :string, :limit => 4
      t.column :nombre_cliente, :string, :limit => 120
      t.column :codigo, :string, :limit => 18
      t.column :fecha_hora_archivo, :datetime
      t.column :fecha_hora_carga, :datetime
      t.column :sucursal, :string, :limit => 10
      t.column :cuenta, :string, :limit => 10
      t.column :nombre_cuenta, :string, :limit => 120
      t.column :nombre_archivo, :string
      t.column :moneda, :string, :limit => 50
      t.column :num_movimientos, :integer
   end
  end

  def self.down
    drop_table :datafiles
  end
end
