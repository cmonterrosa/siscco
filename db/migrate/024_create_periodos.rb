class CreatePeriodos < ActiveRecord::Migration
  def self.up
    create_table :periodos do |t|
      t.column :nombre, :string
      t.column  :dias, :integer
    end
  end

  def self.down
    drop_table :periodos
  end
end
