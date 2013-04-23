class CreateFestivos < ActiveRecord::Migration
  def self.up
    create_table :festivos do |t|
      t.column :fecha, :date
      t.column :descripcion, :string
    end
  end

  def self.down
    drop_table :festivos
  end
end
