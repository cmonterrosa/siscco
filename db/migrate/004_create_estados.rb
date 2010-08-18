class CreateEstados < ActiveRecord::Migration
  def self.up
    create_table :estados do |t|
      t.column :estado, :string
      t.column :edo_inegi, :string
      t.column :edo_renapo, :string
    end

  #---- Cargamos el catalogo ------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/estados.csv").each { |line|
      estado, edo_inegi, edo_renapo = line.split("|")
      Estado.create(:estado => estado, :edo_inegi => edo_inegi, :edo_renapo => edo_renapo)
    }

  end

  def self.down
    drop_table :estados
  end
end
