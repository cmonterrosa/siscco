class CreateExcedentes < ActiveRecord::Migration
  def self.up
    create_table :excedentes do |t|
      t.column :credito_id, :integer
      t.column :monto, :decimal, :precision => 15, :scale => 2
      t.column :fecha_deposito, :datetime
    end
  end

  def self.down
    drop_table :excedentes
  end
end
