class CreateProductos < ActiveRecord::Migration
  def self.up
    create_table :productos do |t|
      t.column :producto, :string
      t.column :intereses, :float
      t.column :moratorio, :float
      t.column :ahorro, :float
      #--- relacion con otras tablas ---
      t.column :periodo_id, :integer
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :productos
  end
end
