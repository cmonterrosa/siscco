class CreateMiembros < ActiveRecord::Migration
  def self.up
    create_table :miembros do |t|
     t.column :credito_id, :integer
     t.column :jerarquia_id, :integer
     t.column :cliente_id, :integer
     #-- columnas de auditoria ----
     t.column :user_id, :integer
     t.column :fecha_hora, :datetime
    end
  end

  def self.down
    drop_table :miembros
  end
end
