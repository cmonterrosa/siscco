class CreateNacionalidads < ActiveRecord::Migration
  def self.up
    create_table :nacionalidads do |t|
      t.column :pais_id, :string
      t.column :pais, :string
      t.column :pais_gent, :string
    end



  #---- Cargamos el catalogo de municipios de chiapas------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/nacionalidades.csv").each { |line|
      pais_id, pais, pais_gent = line.split("|")
      Nacionalidad.create(:pais_id => pais_id, :pais => pais, :pais_gent => pais_gent)
    }

  end

  def self.down
    drop_table :nacionalidads
  end
end
