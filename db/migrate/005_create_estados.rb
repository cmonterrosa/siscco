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






#    @chiapas=Estado.create(:estado => "CHIAPAS")
#              #---- Creacion de municipios ----
#              @tuxtla = @chiapas.municipios.create(:municipio => "TUXTLA GUTIERREZ")
#              @tapachula = @chiapas.municipios.create(:municipio => "TAPACHULA")
#              @SCL = @chiapas.municipios.create(:municipio => "SAN CRISTOBAL DE LAS CASAS")
#
#              #-- Creacion de ejidos ---
#              @ejido_tgz = @tuxtla.ejidos.create(:ejido => "TUXTLA GUTIERREZ")
#              @ejido_jobo = @tuxtla.ejidos.create(:ejido => "EL JOBO")
#              @ejido_tapachula = @tapachula.ejidos.create(:ejido => "LOS NARANJOS")
#              @ejido_tapachula2 = @tapachula.ejidos.create(:ejido => "LAS FLORES")
#
#                        # ----- Creacion de Colonias
#                        @ejido_tgz.colonias.create(:colonia => "CENTRO")
#                        @ejido_tgz.colonias.create(:colonia => "LA LOMITA")
#                        @ejido_tgz.colonias.create(:colonia => "24 DE JUNIO")
#                        @ejido_tgz.colonias.create(:colonia => "POTINASPAK")
#                        @ejido_tgz.colonias.create(:colonia => "POMAROSA")
#                        @ejido_jobo.colonias.create(:colonia => "COPOYA")
#                        @ejido_tapachula.colonias.create(:colonia =>"LAURELES")
#                        @ejido_tapachula.colonias.create(:colonia =>"CENTRO")
#                        @ejido_tapachula.colonias.create(:colonia =>"VISTAHERMOSA")
#                        @ejido_tapachula2.colonias.create(:colonia =>"PLAYA LINDA")
#
#
#    #---- El resto de los estados ------
#
#    Estado.create(:estado => "AGUASCALIENTES")
#    Estado.create(:estado => "BAJA CALIFORNIA")
#    Estado.create(:estado => "CHIHUAHUA")
#    Estado.create(:estado => "VERACRUZ")
#    Estado.create(:estado => "TABASCO")
#    Estado.create(:estado => "MORELOS")
#    Estado.create(:estado => "ESTADO DE MEXICO")
#    Estado.create(:estado => "JALISCO")
#    Estado.create(:estado => "YUCATAN")


  end

  def self.down
    drop_table :estados
  end
end
