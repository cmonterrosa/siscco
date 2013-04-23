class CreateEscolaridads < ActiveRecord::Migration
  def self.up
    create_table :escolaridads do |t|
      t.column :escolaridad, :string
      t.column :estudios_id, :integer

    end

    Escolaridad.create(:escolaridad => "PRIMARIA", :estudios_id => 1)
    Escolaridad.create(:escolaridad => "SECUNDARIA", :estudios_id => 2)
    Escolaridad.create(:escolaridad => "TECNICA O COMERCIAL", :estudios_id => 3)
    Escolaridad.create(:escolaridad => "BACHILLERATO", :estudios_id => 4)
    Escolaridad.create(:escolaridad => "LICENCIATURA", :estudios_id => 5)
    Escolaridad.create(:escolaridad => "POSTGRADO", :estudios_id => 6)
    Escolaridad.create(:escolaridad => "NINGUNA", :estudios_id => 7)
    Escolaridad.create(:escolaridad => "SE IGNORA", :estudios_id => 8)



  end

  def self.down
    drop_table :escolaridads
  end
end
