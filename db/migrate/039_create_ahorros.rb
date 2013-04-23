class CreateAhorros < ActiveRecord::Migration
  def self.up
    create_table :ahorros do |t|
      t.column :monto, :string
      t.column :cliente_id, :integer
      t.column :credito_id, :integer
      t.column :credito_id, :integer
      t.column :hora_fecha, :datetime
    end
  end

  def self.down
    drop_table :ahorros
  end
end
