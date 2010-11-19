class CreateDepositos < ActiveRecord::Migration
  def self.up
    create_table :depositos do |t|
      #No.,Sucursal,Aut.,Código,SubCódigo,Referencia Númerica,Referencia Alfanúmerica,Importe,
      t.column :sucursal, :string, :limit => 20
      t.column :autorizacion, :string, :limit => 20
      t.column :codigo, :string, :limit => 20
      t.column :subcodigo, :string, :limit => 20
      t.column :ref_num, :string, :limit => 20
      t.column :ref_alfa, :string, :limit => 20
      t.column :importe, :string, :limit => 20
      #---- Relaciones con otras tablas -----
      t.column :datafile_id, :integer
    end
  end

  def self.down
    drop_table :depositos
  end
end


