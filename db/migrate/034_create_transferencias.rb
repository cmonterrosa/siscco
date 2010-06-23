class CreateTransferencias < ActiveRecord::Migration
  def self.up
    create_table :transferencias do |t|
      t.column :origen_id, :integer
      t.column :destino_id, :integer
      t.column :user_id, :integer
      t.column :fecha, :date
      t.column :monto, :string
      t.column :observaciones, :string
    end
  end

  def self.down
    drop_table :transferencias
  end
end
