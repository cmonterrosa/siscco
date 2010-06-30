class CreatePromotors < ActiveRecord::Migration
  def self.up
    create_table :promotors do |t|
      t.column :paterno, :string
      t.column :materno, :string
      t.column :nombre, :string
      t.column :direccion, :string
      t.column :telefono, :string, :limit => 10
      t.column :celular, :string, :limit => 10
      t.column :email, :string
      t.column :observaciones, :string
      #---- columnas de auditoria ---
      t.column :user_id, :integer
      t.column :fecha, :date
    end
  end

  def self.down
    drop_table :promotors
  end
end
