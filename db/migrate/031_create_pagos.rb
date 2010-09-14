class CreatePagos < ActiveRecord::Migration
  def self.up
    create_table :pagos do |t|
      t.column :num_pago, :integer
      #--- Valores limites ---
      t.column :fecha_limite, :date
      t.column :capital_minimo, :string
      t.column :interes_minimo, :string
      #---- Datos del pago -----
      t.column :fecha, :date
      t.column :capital, :string
      t.column :interes, :string
      t.column :moratorio, :string
      t.column :pagado, :integer
      t.column :credito_id, :integer
      t.column :cliente_id, :integer
      t.column :descripcion, :string
      t.column :int_devengados, :float
      #---- Datos informativos -----
      t.column :saldo_inicial, :string
      t.column :saldo_final, :string
      t.column :principal_recuperado, :string
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :pagos
  end
end
