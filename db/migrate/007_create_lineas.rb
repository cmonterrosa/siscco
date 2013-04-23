class CreateLineas < ActiveRecord::Migration
  def self.up
    create_table :lineas do |t|
      t.column :cuenta_cheques, :string
      t.column :fecha_aut, :date
      t.column :autorizado, :float
      t.column :estatus, :string
      t.column :gcnf, :string
      t.column :fondeo_id, :integer
      t.column :ctaconcentradora_id, :integer
      t.column :ctaliquidadora_id, :integer
      #---- campo para historial -----
      t.column :estatus, :integer
    end
    @fondeo = Fondeo.create(:fuente => "RECURSOS PROPIOS", :acronimo => "RECURSOS PROPIOS")
    Linea.create(:cuenta_cheques=> "RECURSOS PROPIOS", :fecha_aut => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
                 :fondeo_id => @fondeo.id.to_i)

  end

  def self.down
    drop_table :lineas
  end
end
