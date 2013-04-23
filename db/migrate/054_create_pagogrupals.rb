class CreatePagogrupals < ActiveRecord::Migration
  def self.up
    create_table :pagogrupals do |t|
      #--- Valores limites ---
      t.column :fecha_limite, :date
      t.column :capital_minimo, :float, :limit => 24
      t.column :interes_minimo, :float, :limit => 24
      t.column :pagado, :integer
      t.column :credito_id, :integer
      #---- Datos informativos -----
      t.column :num_pago, :integer
      t.column :saldo_inicial, :float, :limit => 24
      t.column :saldo_final, :float, :limit => 24
      t.column :principal_recuperado, :float, :limit =>24
    end


   # Comenzamos la migracion de los datos
   @pagos = Pago.find(:all, :group=> "credito_id,num_pago", :order => "credito_id")
   unless @pagos.empty?
     @pagos.each do |pago|
       @numclientes = @numclientes = Pago.count("distinct cliente_id", :conditions=>["credito_id = ?", pago.credito.id])
       Pagogrupal.create(:fecha_limite => pago.fecha_limite,
                         :capital_minimo => pago.capital_minimo.to_f * @numclientes,
                         :interes_minimo => pago.interes_minimo.to_f * @numclientes,
                         :pagado => pago.pagado,
                         :credito_id => pago.credito_id,
                         :saldo_inicial => pago.saldo_inicial.to_f * @numclientes,
                         :saldo_final => pago.saldo_final.to_f * @numclientes,
                         :principal_recuperado => pago.principal_recuperado.to_f * @numclientes,
                         :num_pago => pago.num_pago)
       end
   end

   add_column :clientes, :num_exterior, :string, :limit => 10
   add_column :clientes, :num_interior, :string, :limit => 10
  # add_column :clientes, :rol_hogar_id, :integer
  # add_column :clientes, :edo_residencia_id, :integer
   add_column :clientes, :fecha_captura, :date
  # add_column :negocios, :ubicacion_negocio_id, :integer
    
 end

  def self.down
    drop_table :pagogrupals
    remove_column :clientes, :num_exterior
    remove_column :clientes, :num_interior
    remove_column :clientes, :rol_hogar_id
    remove_column :clientes, :edo_residencia_id
    remove_column :negocios, :ubicacion_negocio_id

    remove_column :clientes, :rol_hogar
    remove_column :clientes, :edo_residencia

    execute("TRUNCATE TABLE civils")
    execute("TRUNCATE TABLE destinos")

  end
end
