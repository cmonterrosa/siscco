class CreateColonias < ActiveRecord::Migration
  def self.up
    create_table :colonias do |t|
      t.column :colonia, :string
      t.column :clave_inegi, :string
      t.column :ejido_id, :integer
      t.column :user_id, :integer
       t.column :fecha_hora, :datetime
    end
  end

  def self.down
    drop_table :colonias
  end
end
