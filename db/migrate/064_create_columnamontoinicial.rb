class CreateColumnamontoinicial < ActiveRecord::Migration
  def self.up
    add_column :creditos, :monto_inicial, :decimal, :precision => 15, :scale => 10
    #--- Agregamos timestamps
    add_column :creditos, :updated_at, :datetime
    add_column :creditos, :created_at, :datetime
  end

  def self.down
    remove_column :creditos, :monto_inicial
    remove_column :creditos, :updated_at
    remove_column :creditos, :created_at
  end
end
