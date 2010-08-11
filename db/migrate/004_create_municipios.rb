class CreateMunicipios < ActiveRecord::Migration
  def self.up
    create_table :municipios do |t|
      t.column :municipio, :string
      t.column :clave_inegi, :string
      t.column :estado_id, :integer
    end


  #---- Cargamos el catalogo de municipios de chiapas------
    File.open("#{RAILS_ROOT}/db/migrate/catalogos/municipioschiapas.csv").each { |line|
      clave_inegi, edo, municipio = line.split("|")
      @estado = Estado.find(:first, :conditions => ["edo_inegi = ?", edo])
      Municipio.create(:municipio => municipio, :clave_inegi => clave_inegi, :estado_id => @estado.id.to_i)
    }




  end

  def self.down
    drop_table :municipios
  end
end
