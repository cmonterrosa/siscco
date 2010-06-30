class CreateUsers < ActiveRecord::Migration
  def self.up
  create_table :users do |t|
  t.column :login, :string, :default => nil
  t.column :password, :string, :default => nil
  t.column :nombre, :string
  t.column :rol_id, :integer, :default => 1
  #---- columnas de auditoria ---
  t.column :user_id, :integer
  t.column :fecha_hora, :datetime
end

   User.create(:login => 'administrador',
  :password => 'password',
  :nombre => "administrador del sistema",
  :password_confirmation => 'password', :rol_id => 5)

      User.create(:login => 'cmonterrosa',
  :password => 'solaris',
  :nombre => "capturista de prueba",
  :password_confirmation => 'password', :rol_id => 2)

  end

  def self.down
  drop_table :users
  end
end
