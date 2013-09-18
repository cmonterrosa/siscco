class BaseValores < ActiveRecord::Migration
  def self.up
    add_column(:creditos, :estado, :string)
  end

  def self.down
    remove_column(:creditos, :estado)
  end

end
