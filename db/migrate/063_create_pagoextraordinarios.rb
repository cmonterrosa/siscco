class CreatePagoextraordinarios < ActiveRecord::Migration
  def self.up
    create_table :pagoextraordinarios do |t|
      t.column :extraordinario_id, :integer
      t.column :fecha, :date
      t.column :cantidad, :decimal, :precision => 15, :scale => 10
    end
  end

  def self.down
    drop_table :pagoextraordinarios
  end
end
