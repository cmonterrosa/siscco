class CreateColumnaliquidacion < ActiveRecord::Migration
  def self.up
    add_column :creditos, :fecha_liquidacion, :datetime
    change_column :transaccions, :monto, :decimal, :precision => 15, :scale => 2
  end

  def self.down
    remove_column :creditos, :fecha_liquidacion
    change_column :transaccions, :monto, :float
  end
end
