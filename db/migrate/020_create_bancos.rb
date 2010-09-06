class CreateBancos < ActiveRecord::Migration
  def self.up
    create_table :bancos do |t|
      t.column :nombre, :string
      t.column :num_cuenta, :string
      t.column :num_sucursal, :string, :limit => 4
      t.column :cta_contable, :string, :limit => 12
      t.column :direccion, :string
      t.column :telefono, :string
      t.column :cta_concentradora, :string
      t.column :cta_liquidadora, :string
      t.column :municipio_id, :integer
    end
  end

  def self.down
    drop_table :bancos
  end
end
