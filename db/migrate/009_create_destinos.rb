class CreateDestinos < ActiveRecord::Migration
  def self.up
    create_table :destinos do |t|
      t.column :destino, :string
#      t.column :user_id, :integer
#      t.column :fecha_hora, :datetime
    end

    #---- Cargamos el catalogo destino ------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/destino_credito.csv").each { |line|
      id, destino = line.split("|")
      Destino.create(:destino => destino)
    }
    
  end

  def self.down
    drop_table :destinos
  end
end
