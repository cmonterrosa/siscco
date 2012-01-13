class CreateCambiodatos < ActiveRecord::Migration
  def self.up
    # tablas cambio de tipo de dato
    change_column :fechavalors, :importe, :decimal, :precision => 15, :scale => 2
    change_column :pagos, :capital_minimo, :decimal, :precision => 15, :scale => 2
    change_column :pagos, :interes_minimo, :decimal, :precision => 15, :scale => 2
    change_column :pagos, :moratorio, :decimal, :precision => 15, :scale => 2
    change_column :pagos, :saldo_inicial, :decimal, :precision => 15, :scale => 2
    change_column :pagos, :saldo_final, :decimal, :precision => 15, :scale => 2
    change_column :pagos, :principal_recuperado, :decimal, :precision => 15, :scale => 2
    change_column :pagogrupals, :capital_minimo, :decimal, :precision => 15, :scale => 2
    change_column :pagogrupals, :interes_minimo, :decimal, :precision => 15, :scale => 2
    change_column :pagogrupals, :principal_recuperado, :decimal, :precision => 15, :scale => 2
  end

  def self.down
#    change_column :fechavalors, :importe, :string
#    change_column :pagos, :capital_minimo, :string
#    change_column :pagos, :interes_minimo, :string
#    change_column :pagos, :moratorio, :string
#    change_column :pagos, :saldo_inicial, :string
#    change_column :pagos, :saldo_final, :string
#    change_column :pagos, :principal_recuperado, :string
#    change_column :pagogrupals, :capital_minimo, :float
#    change_column :pagogrupals, :interes_minimo, :float
#    change_column :pagogrupals, :principal_recuperado, :float
  end
end
