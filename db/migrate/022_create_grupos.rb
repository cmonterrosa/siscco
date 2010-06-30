class CreateGrupos < ActiveRecord::Migration
  def self.up
    create_table :grupos do |t|
      t.column :nombre, :string
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha_hora, :datetime
    end
    #--- Por defecto no pertenecen a ningun grupo ---
    Grupo.create(:nombre =>"Ninguno")


  end

  def self.down
    drop_table :grupos
  end
end
