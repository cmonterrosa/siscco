class CreateMunicipios < ActiveRecord::Migration
  def self.up
    create_table :municipios do |t|
      t.column :municipio, :string
      t.column :clave_inegi, :string
      t.column :estado_id, :integer
    end
  end

  def self.down
    drop_table :municipios
  end
end
