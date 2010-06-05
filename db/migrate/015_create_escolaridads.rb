class CreateEscolaridads < ActiveRecord::Migration
  def self.up
    create_table :escolaridads do |t|
      t.column :escolaridad, :string
    end

    Escolaridad.create(:escolaridad => "NINGUNA")
    Escolaridad.create(:escolaridad => "PRIMARIA")
    Escolaridad.create(:escolaridad => "SECUNDARIA")
    Escolaridad.create(:escolaridad => "PREPARATORIA")
    Escolaridad.create(:escolaridad => "CARRERA TRUNCA")
    Escolaridad.create(:escolaridad => "LICENCIATURA")
    Escolaridad.create(:escolaridad => "POSGRADO")

  end

  def self.down
    drop_table :escolaridads
  end
end
