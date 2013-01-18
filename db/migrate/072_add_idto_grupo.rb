class AddIdtoGrupo < ActiveRecord::Migration
  def self.up
    add_column :grupos, :identificador, :string, :limit => 7
    Grupo.find(:all).each do |g|
      last_credito = Credito.find(:first, :conditions => ["grupo_id = ?", g.id], :order => "fecha_captura")
      if last_credito
        g.update_attributes!(:identificador => last_credito.linea.gcnf.strip) unless g.identificador
      end
    end

#----- Generar masivamente los identicadores para los grupos existentes  ----
#    Grupo.find(:all).each do |g|
#        id = Array.new(2) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
#        while not (Grupo.find_by_identificador(id)).nil?
#            id = Array.new(2) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
#        end
#        g.update_attributes!(:identificador => id.to_s.ljust(6, "0")) unless g.identificador
#    end
  end

  def self.down
    remove_column :grupos, :identificador
  end
end
