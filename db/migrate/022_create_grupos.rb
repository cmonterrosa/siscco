class CreateGrupos < ActiveRecord::Migration
  def self.up
    create_table :grupos do |t|
      t.column :nombre, :string
    end
  end

  def self.down
    drop_table :grupos
  end
end
