class AddIvAtoPago < ActiveRecord::Migration
  def self.up
      #### Modificacion en pagos #############
      add_column :pagos, :iva, :decimal, :precision => 15, :scale => 2
      add_column :pagogrupals, :iva, :decimal, :precision => 15, :scale => 2
  end

  def self.down
    remove_column :pagos, :iva
    remove_column :pagogrupals, :iva
  end
end
