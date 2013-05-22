class AddPaternoMaternoNombreToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :paterno, :string, :limit => 40
    add_column :users, :materno, :string, :limit => 40
    add_column :users, :nombre, :string, :limit => 60
    add_column :users, :direccion, :string, :limit => 120
    add_column :users, :tel_celular, :string, :limit => 10
  end

  def self.down
    remove_column :users, :paterno
    remove_column :users, :materno
    remove_column :users, :nombre
    remove_column :users, :direccion
    remove_column :users, :tel_celular
  end
end
