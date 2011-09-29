class CreateColumnafvalorestatus < ActiveRecord::Migration
  def self.up
    add_column :fechavalors, :tipo, :string, :limit => 20
  end

  def self.down
    remove_column :fechavalors, :tipo
  end
end
