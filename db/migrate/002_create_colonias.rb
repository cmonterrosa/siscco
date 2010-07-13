class CreateColonias < ActiveRecord::Migration
  def self.up
    create_table :colonias do |t|
      t.column :colonia, :string
      t.column :clave_inegi, :string
      t.column :ejido_id, :integer
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :colonias
  end
end
