class CreatePagoslineas < ActiveRecord::Migration
  def self.up
    create_table :pagoslineas do |t|
      t.column :linea_id, :integer
      t.column :fecha, :date
      t.column :monto, :string
      t.column :observaciones, :string
    end
  end

  def self.down
    drop_table :pagoslineas
  end
end
