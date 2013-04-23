class UpdateTransaccions < ActiveRecord::Migration
  def self.up
    add_column :transaccions, :datafile_id, :integer
    #--- removemos columnas de tabla pagos
    remove_column :pagos, :fecha
    remove_column :pagos, :capital
    remove_column :pagos, :interes
    remove_column :pagos, :comisiones
    remove_column :pagos, :iva_comisiones
    remove_column :pagos, :iva_moratorio
    remove_column :pagos, :st
  end

  def self.down
    remove_column :transaccions, :datafile_id
    #---- agregamos columnas a la tabla pagos
    add_column :pagos, :fecha, :date
    add_column :pagos, :capital, :string
    add_column :pagos, :interes, :string
    add_column :pagos, :comisiones, :string
    add_column :pagos, :iva_comisiones, :string
    add_column :pagos, :iva_moratorio, :string
    add_column :pagos, :st, :string

  end
end