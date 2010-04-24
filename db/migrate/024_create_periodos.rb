class CreatePeriodos < ActiveRecord::Migration
  def self.up
    create_table :periodos do |t|
      t.column :nombre, :string
      t.column  :dias, :integer
    end

    Periodo.create(:nombre => "Dia", :dias => 1)
    Periodo.create(:nombre => "Semana", :dias => 7)
    Periodo.create(:nombre => "Quincena", :dias => 15)
    Periodo.create(:nombre => "Mes", :dias => 30)
    Periodo.create(:nombre => "Bimestre", :dias => 60)
    Periodo.create(:nombre => "Semestre", :dias => 180)
    Periodo.create(:nombre => "Año", :dias => 365)

  end

  def self.down
    drop_table :periodos
  end
end
