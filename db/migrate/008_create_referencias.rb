class CreateReferencias < ActiveRecord::Migration
  def self.up
    create_table :referencias do |t|
      t.column :paterno, :string
      t.column :materno, :string
      t.column :nombre, :string
      t.column :parentesco, :string
      t.column :direccion, :string
      t.column :telefono, :string, :limit=>10
      t.column :tipo, :string
      t.column :credito_id, :integer
   end

    create_table :garantias_referencias, :id => false do |t|
      t.column :referencia_id, :integer
      t.column :garantia_id, :integer
    end
  end

  def self.down
    drop_table :referencias
    drop_table :garantias_referencias
  end
end
