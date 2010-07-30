class CreatePeriodos < ActiveRecord::Migration
  def self.up
    create_table :periodos do |t|
      t.column :nombre, :string
      t.column  :dias, :integer
      t.column :pagos_mes, :integer
    end

    Periodo.create(:nombre => "Semanales", :dias => 7, :pagos_mes => 4)
    Periodo.create(:nombre => "Quincenales", :dias => 15, :pagos_mes => 2)
    Periodo.create(:nombre => "Mensuales", :dias => 30, :pagos_mes => 1)

  end

  def self.down
    drop_table :periodos
  end
end
