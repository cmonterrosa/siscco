class CreateEjidos < ActiveRecord::Migration
  def self.up
    create_table :ejidos do |t|
      t.column :ejido, :string
      t.column :clave_inegi, :string
      t.column :municipio_id, :integer
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :ejidos
  end
end
