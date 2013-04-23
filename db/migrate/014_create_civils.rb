class CreateCivils < ActiveRecord::Migration
  def self.up
    create_table :civils do |t|
      t.column :civil, :string
    end

    #---- Cargamos el catalogo edo_civil ------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/edo_civil.csv").each { |line|
      id, civil = line.split("|")
      Civil.create(:civil => civil)
    }

  end

  def self.down
    drop_table :civils
  end
end
