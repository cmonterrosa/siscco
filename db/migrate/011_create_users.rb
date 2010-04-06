class CreateUsers < ActiveRecord::Migration
  def self.up
  create_table :users do |t|
  t.column :login, :string, :default => nil
  t.column :password, :string, :default => nil
  t.column :rol_id, :integer, :default => 1
end

   User.create(:login => 'administrador',
  :password => 'password',
  :password_confirmation => 'password', :rol_id => 5)

  end

  def self.down
  drop_table :users
  end
end
