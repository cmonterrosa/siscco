class ModifyProductos < ActiveRecord::Migration
  def self.up
    add_column :productos, :moratorio_flat, :float
    rename_column :productos, :moratorio, :moratorio_ssi

  end

  def self.down
    remove_column :productos, :moratorio_flat
    rename_column :productos, :moratorio_ssi, :moratorio
  end
end