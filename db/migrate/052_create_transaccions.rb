class CreateTransaccions < ActiveRecord::Migration
  def self.up
    create_table :transaccions do |t|
      t.column :monto, :string
      t.column :pago_id, :integer
      t.column :tipo_transaccion_id, :integer
      t.column :fecha_hora_aplicacion, :datetime
    end
  end

  def self.down
    drop_table :transaccions
  end
end
