class CreateGrupos < ActiveRecord::Migration
  def self.up
    create_table :grupos do |t|
      t.column :nombre, :string
       #---- campo para historial -----
      t.column :st, :integer
    end
    #--- Por defecto no pertenecen a ningun grupo ---
    Grupo.create(:nombre =>"Ninguno")


  end

  def self.down
    drop_table :grupos
  end
end
