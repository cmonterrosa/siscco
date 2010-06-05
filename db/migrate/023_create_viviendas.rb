class CreateViviendas < ActiveRecord::Migration
  def self.up
    create_table :viviendas do |t|
      t.column :tipo_vivienda, :string
    end
  end

  def self.down
    drop_table :viviendas
  end
end
