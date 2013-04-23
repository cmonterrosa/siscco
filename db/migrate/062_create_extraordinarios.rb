class CreateExtraordinarios < ActiveRecord::Migration
  def self.up
    create_table :extraordinarios do |t|
      t.column :credito_id, :integer
      t.column :status, :integer
      t.column :interes, :decimal,  :precision => 15, :scale => 10
      t.column :capital, :decimal,  :precision => 15, :scale => 10
      t.column :proporcion_capital, :decimal, :precision => 15, :scale => 10
      t.column :proporcion_interes, :decimal, :precision => 15, :scale => 10
    end
  #--- Agregamos la columna tipo a la tabla de creditos
  add_column :creditos, :tipo_aplicacion, :string
  end

  def self.down
    drop_table :extraordinarios
    remove_column :creditos, :tipo_aplicacion
  end
end
