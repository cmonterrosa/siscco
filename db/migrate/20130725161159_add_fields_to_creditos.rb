class AddFieldsToCreditos < ActiveRecord::Migration
  def self.up
    add_column :creditos, :user_id, :integer
    add_column :creditos, :cancel, :boolean
  end

  def self.down
    remove_column :creditos, :user_id
    remove_column :creditos, :cancel
  end
end
