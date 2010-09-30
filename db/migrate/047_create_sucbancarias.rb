class CreateSucbancarias < ActiveRecord::Migration
  def self.up
    create_table :sucbancarias do |t|
      t.column :nombre, :string
      t.column :banco_id, :integer
    end
  end

  def self.down
    drop_table :sucbancarias
  end
end
