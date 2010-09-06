class CreateCuentas < ActiveRecord::Migration
  def self.up
    create_table :cuentas do |t|
      t.column :iEjer, :integer
      t.column :iMes, :integer
      t.column :sTpPol, :string, :limit => 3
      t.column :sPolNum, :string, :limit => 6
      t.column :sPolMov, :string, :limit => 6
      t.column :iDia, :integer
      t.column :sCtaNum, :string, :limit => 20
      t.column :sNombre, :string, :limit => 50
      t.column :iNatura, :integer
      t.column :rImpMov, :real
      t.column :sCvIVA, :string, :limit => 1
      t.column :iAplica, :integer
      t.column :sCnc, :string, :limit => 3
      t.column :sRefere, :string,:limit => 8
      t.column :sClvCnc, :string, :limit => 3
      t.column :sNatMov, :string, :limit => 1
      t.column :rImpMovRS, :real
      t.column :sCtaNom, :string, :limit => 30
    end
  end

  def self.down
    drop_table :cuentas
  end
end
