class CreateGarantias < ActiveRecord::Migration
  def self.up
    create_table :garantias do |t|
      t.column :garantia, :string
    end
  end

  def self.down
    drop_table :garantias
  end
end
