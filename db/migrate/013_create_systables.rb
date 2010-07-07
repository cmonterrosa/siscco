class CreateSystables < ActiveRecord::Migration
  def self.up
    create_table :systables do |t|
      t.column :controller_id, :integer
      t.column :rol_id, :integer
      t.column :consultar, :integer, :default=>1
      t.column :actualizar, :integer, :default=>0
      t.column :insertar, :integer, :default=>1
      t.column :eliminar, :integer, :default=>1
    end

    #--- El administrador tiene acceso total ---

    #---- Creamos los permisos para que todos los perfiles puedan iniciar y cerrar sesion ----
    Rol.find(:all).each do |rol|
      Systable.create(:controller_id => 1, :rol_id => rol.id)
    end

  end

  def self.down
    drop_table :systables
  end
end
