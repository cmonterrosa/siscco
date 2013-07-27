class CreateListaNegras < ActiveRecord::Migration
  def self.up
    create_table :lista_negras do |t|
      t.string :paterno, :limit => 40
      t.string :materno, :limit => 40
      t.string :nombre, :limit => 60
      t.string :curp, :limit => 18
      t.string :rfc, :limit => 13
      t.string :tipo, :limit => 80
      t.string :genero, :limit => 25
      t.string :observaciones
      t.boolean :activo
      t.timestamps
    end
  end

  def self.down
    drop_table :lista_negras
  end
end
