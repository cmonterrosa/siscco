class CreateTipoTransaccions < ActiveRecord::Migration
  def self.up
    create_table :tipo_transaccions do |t|
      t.column :descripcion, :string
      t.column :prioridad, :integer
    end
    
    #IVA POR COMISIONES COBRADAS
                  #COMISIONES COBRADAS
                  #IVA POR INTERESES MORATORIOS
                  #INTERESES MORATORIOS
                  #IVA POR INTERESES NORMALES
                  #INTERESES NORMALES
                  #CAPITAL

    TipoTransaccion.create(:descripcion => "CAPITAL", :prioridad => 6)
    TipoTransaccion.create(:descripcion => "INTERESES NORMALES", :prioridad => 5)
    TipoTransaccion.create(:descripcion => "IVA POR INTERESES NORMALES", :prioridad => 4)
     TipoTransaccion.create(:descripcion => "INTERESES MORATORIOS", :prioridad => 3)
     TipoTransaccion.create(:descripcion => "IVA POR INTERESES MORATORIOS", :prioridad => 2)
     TipoTransaccion.create(:descripcion => "COMISIONES COBRADAS", :prioridad => 1)


  end

  def self.down
    drop_table :tipo_transaccions
  end
end
