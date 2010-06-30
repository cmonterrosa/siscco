class CreateSucursals < ActiveRecord::Migration
  def self.up
    create_table :sucursals do |t|
      t.column :nombre, :string
      t.column :gerente, :string
      t.column :telefono, :string
      t.column :direccion, :string
      t.column :codigo_postal, :string
      t.column :colonia_id, :integer
      t.column :user_id, :integer
      t.column :fecha, :date
     end
  end

  def self.down
    drop_table :sucursals
  end
end
