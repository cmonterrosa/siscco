class CreateProductos < ActiveRecord::Migration
  def self.up
    create_table :productos do |t|
      t.column :producto, :string
      t.column :tipo, :string
      t.column :intereses, :float
      t.column :iva_intereses, :float
      t.column :moratorio, :float
      t.column :multa, :float
      t.column :iva_multa, :float
      t.column :garantia, :string
      #--- relacion con otras tablas ---
      t.column :periodo_id, :integer
      t.column :grupo_id, :integer
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha, :date
    end
  end

  def self.down
    drop_table :productos
  end
end
