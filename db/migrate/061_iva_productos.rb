class IvaProductos < ActiveRecord::Migration
  def self.up
    add_column :productos, :iva, :decimal, :precision => 8, :scale => 2
    add_column :productos, :gastos_cobranza, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :productos, :iva
    remove_column :productos, :gastos_cobranza
  end
end

