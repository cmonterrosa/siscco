class CreateRols < ActiveRecord::Migration
  def self.up
    create_table :rols do |t|
      t.column :nombre, :string
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha, :date
    end

     Rol.create(:nombre=> "clientes")
     Rol.create(:nombre => 'capturistas')
     Rol.create(:nombre => 'promotores')
     Rol.create(:nombre => 'gerentes')
     Rol.create(:nombre => 'administradores')
   end

  def self.down
    drop_table :rols
  end
end
