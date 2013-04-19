class AddIndexClienteGrupo < ActiveRecord::Migration
  def self.up
     add_index "clientes_grupos", "activo"
  end

  def self.down
     remove_index "clientes_grupos", "activo"
  end
end
