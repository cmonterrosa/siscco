class CreateLineas < ActiveRecord::Migration
  def self.up
    create_table :lineas do |t|
      t.column :cuenta_cheques, :string
      t.column :fecha_aut, :date
      t.column :autorizado, :float
      t.column :estatus, :string
      t.column :gcnf, :string
      t.column :fondeo_id, :integer
      t.column :cta_concentradora, :string
      #---- campo para historial -----
      t.column :st, :integer
    end
    @fondeo = Fondeo.create(:fuente => "RECURSOS PROPIOS")
    Linea.create(:cuenta_cheques=> "RECURSOS PROPIOS", :fecha_aut => Time.now,
                 :fondeo_id => @fondeo.id.to_i)

  end

  def self.down
    drop_table :lineas
  end
end
