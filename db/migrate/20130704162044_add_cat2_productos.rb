class AddCat2Productos < ActiveRecord::Migration
  def self.up
    #### Modificacion en productos #############
    add_column :productos, :cat, :decimal, :precision => 15, :scale => 2
    add_column :productos, :tasa_mensual_ssg, :decimal, :precision => 15, :scale => 2
    add_column :productos, :tasa_comision_apertura, :decimal, :precision => 15, :scale => 2
    add_column :productos, :iva_comision_apertura, :decimal, :precision => 15, :scale => 2
    add_column :productos, :tasa_anualizada_moratoria, :decimal, :precision => 15, :scale => 2

    ###### Agregamos la columnas para historico en el credito #######
    add_column :creditos, :cat, :decimal, :precision => 15, :scale => 2
    add_column :creditos, :cat_comision_apertura, :decimal, :precision => 15, :scale => 2
    add_column :creditos, :interes_global, :decimal, :precision => 15, :scale => 2
    add_column :creditos, :iva_global, :decimal, :precision => 15, :scale => 2
  end

  def self.down
    remove_column :productos, :cat
    remove_column :productos, :tasa_mensual_ssg
    remove_column :productos, :tasa_comision_apertura
    remove_column :productos, :iva_comision_apertura
    remove_column :productos, :tasa_anualizada_moratoria
    remove_column :creditos, :cat
    remove_column :creditos, :cat_comision_apertura
    remove_column :creditos, :interes_global
    remove_column :creditos, :iva_global
  end
end
