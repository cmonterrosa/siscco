class CreateCuentas < ActiveRecord::Migration
  def self.up
    create_table :cuentas do |t|
      t.column :sCtaNum, :string, :limit => 20
      t.column :sNombre, :string, :limit => 50
    end
  end

  def self.down
    drop_table :cuentas
  end
end
