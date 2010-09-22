class Datafile < ActiveRecord::Base

  def initialize(params = nil)
    super
      self.fecha_hora_carga = Time.now unless self.fecha_hora_carga
  end




  def self.save_file(upload)
    name =  upload["file"].original_filename
    directory = "public/tmp"
    # ---  Creamos el Path ----
    path = File.join(directory, name)
    # ---- Escribimos el archivo  -----
    File.open(path, "wb") { |f| f.write(upload['file'].read) }
    @data = Datafile.new(:nombre_archivo => name)
    #---- Primero vamos a verificar si el encabezado es correcto y no se repite ------
    if encabezado_valido?(name) && @data
       if inserta_metadatos(name, @data)
          return true
       else
          File.delete("#{RAILS_ROOT}/public/tmp/#{name}") if File.exists?("#{RAILS_ROOT}/public/tmp/#{name}")
          return false
       end
    else
      File.delete("#{RAILS_ROOT}/public/tmp/#{name}") if File.exists?("#{RAILS_ROOT}/public/tmp/#{name}")
      return false
    end
  end

end #-- Termina clase
