class CreateRolHogars < ActiveRecord::Migration
  def self.up
    create_table :rol_hogars do |t|
      t.column :rol, :string
    end

    #---- Cargamos el catalogo rol_hogar ------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/rol_hogar.csv").each { |line|
      id, rol, alias0, alias1, alias3 = line.split("|")
      RolHogar.create(:rol => rol)
    }

    #    Truncar tabla destinos antes
    #---- Cargamos el catalogo destino ------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/destino_credito.csv").each { |line|
      id, destino = line.split("|")
      Destino.create(:destino => destino)
    }

    #    Truncar tabla edo_civil antes
    #---- Cargamos el catalogo edo_civil ------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/edo_civil.csv").each { |line|
      id, civil = line.split("|")
      Civil.create(:civil => civil)
    }

  end

  def self.down
    drop_table :rol_hogars
  end
end
