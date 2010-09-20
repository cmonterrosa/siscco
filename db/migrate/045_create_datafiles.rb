class CreateDatafiles < ActiveRecord::Migration
  def self.up
    create_table :datafiles do |t|
      t.column :numero, :string, :limit => 4
      t.column :clave, :string, :limit => 4
      t.column :fecha_hora_archivo, :datetime
      t.column :fecha_hora_carga, :datetime
      t.column :nombre_archivo, :string
      t.column :num_lineas, :integer
    end
  end

  def self.down
    drop_table :datafiles
  end
end
