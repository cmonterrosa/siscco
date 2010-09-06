class CreateProductos < ActiveRecord::Migration
  def self.up
    create_table :productos do |t|
      t.column :producto, :string, :limit => 100
      t.column :intereses, :float
      t.column :moratorio, :float
      t.column :ahorro, :float
      t.column :num_pagos, :integer
      t.column :tasa_anualizada, :string, :limit => 10
      #--- relacion con otras tablas ---
      t.column :periodo_id, :integer
    end
  end

  def self.down
    drop_table :productos
  end
end
