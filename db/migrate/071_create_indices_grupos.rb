class CreateIndicesGrupos < ActiveRecord::Migration
  def self.up
    add_index(:clientes, [:paterno, :materno, :nombre], :name => 'paterno_materno_nombre')
    add_index(:clientes, [:curp], :name => 'curp')
  end

  def self.down
    remove_index :clientes, :name => 'paterno_materno_nombre'
    remove_index :clientes, :name => 'curp'
  end
end

