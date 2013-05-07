class CreateCampos < ActiveRecord::Migration
  def self.up
    add_column :datafiles, :cksum, :string
    add_column :productos, :gastos_judiciales, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :datafiles, :cksum
    remove_column :productos, :gastos_judiciales
  end
end
