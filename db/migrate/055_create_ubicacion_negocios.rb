class CreateUbicacionNegocios < ActiveRecord::Migration
  def self.up
    create_table :ubicacion_negocios do |t|
      t.column :ubicacion, :string
    end

    #---- Cargamos el catalogo ubicacion_negocio ------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/ubicacion_negocio.csv").each { |line|
      id, ubicacion = line.split("|")
      UbicacionNegocio.create(:ubicacion => ubicacion)
    }

  end

  def self.down
    drop_table :ubicacion_negocios
  end
end
