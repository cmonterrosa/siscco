class CreateMovimientos < ActiveRecord::Migration
  def self.up
    create_table :movimientos do |t|
      t.column :tipo, :string
      t.column :capital, :float
      t.column :fecha, :date
      t.column :interes, :float
      t.column :concepto, :string
      #--- Relacion con la tabla credito ---
      t.column :pago_id, :integer
    end
  end

  def self.down
    drop_table :movimientos
  end
end
