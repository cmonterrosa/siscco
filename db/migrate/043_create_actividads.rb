class CreateActividads < ActiveRecord::Migration
  def self.up
    create_table :actividads do |t|
      t.column :clave_inegi, :string
      t.column :actividad, :string
    end

    #---- Cargamos el catalogo de actividades------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/actividades.csv").each { |line|
      clave_inegi, actividad = line.split("|")
      Actividad.create(:clave_inegi => clave_inegi, :actividad => actividad)
    }

  end

  def self.down
    drop_table :actividads
  end
end
