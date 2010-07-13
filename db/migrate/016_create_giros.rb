class CreateGiros < ActiveRecord::Migration
  def self.up
    create_table :giros do |t|
      t.column :giro, :string
      t.column :codigo, :string
      t.column :subsector, :string
      #---- campo para historial -----
      t.column :st, :integer
    end
  end

  def self.down
    drop_table :giros
  end
end
