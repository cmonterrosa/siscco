class ChangeProductos < ActiveRecord::Migration
  def self.up
    add_column :productos, :tasa_mensual_flat, :float
  end

  def self.down
    remove_column :productos, :tasa_mensual_flat
  end
end

