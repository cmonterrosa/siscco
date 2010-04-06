class CreateGiros < ActiveRecord::Migration
  def self.up
    create_table :giros do |t|
      t.column :subsector, :string
      t.column :codigo, :string
      t.column :giro, :string
    end
  end

  def self.down
    drop_table :giros
  end
end
