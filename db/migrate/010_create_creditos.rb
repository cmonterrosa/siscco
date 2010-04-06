class CreateCreditos < ActiveRecord::Migration
  def self.up
    create_table :creditos do |t|
      t.column :fecha_inicio, :date
      t.column :fecha_fin, :date
      t.column :plaza, :string
      t.column :num_referencia, :string
      #--- aqui van las relaciones con las otras tablas ----
      t.column :linea_id, :integer
      t.column :banco_id, :integer
      t.column :cliente_id, :integer
      t.column :promotor_id, :integer
      t.column :destino_id, :integer
      t.column :grupo_id, :integer
    end
  end

  def self.down
    drop_table :creditos
  end
end
