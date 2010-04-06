class CreateDestinos < ActiveRecord::Migration
  def self.up
    create_table :destinos do |t|
      t.column :destino, :string
    end
  end

  def self.down
    drop_table :destinos
  end
end
