class CreateLocalidads < ActiveRecord::Migration
  def self.up
    create_table :localidads do |t|
      t.column :loc_id, :string
      t.column :municipio_id, :integer
      t.column :localidad, :string
    end

      #---- Cargamos el catalogo de localidades de chiapas------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/localidades.csv").each { |line|
      loc_id, municipio_id, localidad = line.split("|")
      @municipio= Municipio.find(:first, :conditions => ["clave_inegi = ?", municipio_id])
      Localidad.create(:loc_id => loc_id, :localidad => localidad, :municipio_id => @municipio.id)
    }

  end

  def self.down
    drop_table :localidads
  end
end
