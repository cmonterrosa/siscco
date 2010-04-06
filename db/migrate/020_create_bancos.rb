class CreateBancos < ActiveRecord::Migration
  def self.up
    create_table :bancos do |t|
      t.column :nombre, :string
      t.column :num_cuenta, :string
      t.column :titular, :string
      t.column :direccion, :string
      t.column :telefono, :string
      t.column :colonia_id, :string
    end
  end

  def self.down
    drop_table :bancos
  end
end
