class CreateGiros < ActiveRecord::Migration
  def self.up
    create_table :giros do |t|
      t.column :giro, :string
      t.column :codigo, :string
      t.column :subsector, :string
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha, :date
    end
  end

  def self.down
    drop_table :giros
  end
end
