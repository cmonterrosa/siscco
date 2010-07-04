class CreatePeriodos < ActiveRecord::Migration
  def self.up
    create_table :periodos do |t|
      t.column :nombre, :string
      t.column  :dias, :integer
    end

    Periodo.create(:nombre => "Diarios", :dias => 1)
    Periodo.create(:nombre => "Semanales", :dias => 7)
    Periodo.create(:nombre => "Quincenales", :dias => 15)
    Periodo.create(:nombre => "Mensuales", :dias => 30)
    Periodo.create(:nombre => "Bimestrales", :dias => 60)
    Periodo.create(:nombre => "Semestrales", :dias => 180)
    Periodo.create(:nombre => "Anuales", :dias => 365)

  end

  def self.down
    drop_table :periodos
  end
end
