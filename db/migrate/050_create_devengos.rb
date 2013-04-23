class CreateDevengos < ActiveRecord::Migration
  def self.up
    create_table :devengos do |t|
      t.column :fecha, :date
      t.column :dia, :integer
      t.column :semana, :integer
      t.column :generacion_obligacion, :string, :limit => 18
      t.column :vto_amortizacion, :string, :limit => 18
      t.column :cuenta_contable_interes, :string, :limit => 18
      t.column :credito_id, :integer
    end
  end

  def self.down
    drop_table :devengos
  end
end
