class CreateJerarquias < ActiveRecord::Migration
  def self.up
    create_table :jerarquias do |t|
      t.column :jerarquia, :string
    end
  end

  def self.down
    drop_table :jerarquias
  end
end
