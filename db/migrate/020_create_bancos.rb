class CreateBancos < ActiveRecord::Migration
  def self.up
    create_table :bancos do |t|
      t.column :nombre, :string
      t.column :num_cuenta, :string
      t.column :titular, :string
      t.column :direccion, :string
      t.column :telefono, :string
      t.column :colonia_id, :integer
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha_hora, :datetime
    end
  end

  def self.down
    drop_table :bancos
  end
end
