class CreateColumnaarchivoerror < ActiveRecord::Migration
  def self.up
    add_column :datafiles, :archivo_na, :string
    add_column :datafiles, :archivo_errores, :string
    #---- cambiamos el tipo de aplicacion ---
    Credito.find(:all).each do |x| x.update_attributes(:tipo_aplicacion => "EXTRAORDINARIO") end
  end

  def self.down
    remove_column :datafiles, :archivo_na
    remove_column :datafiles, :archivo_errores
  end
end
