class Grupo < ActiveRecord::Base
  has_and_belongs_to_many :clientes
  has_many :productos
  has_many :creditos
  #---- relacion ficticia -----
   has_many :clientegrupos
   validates_uniqueness_of :identificador, :scope => "nombre", :message => ", Ese grupo y propuesta estan registradas."


#  def before_save
#        id = Array.new(2) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
#        while not (Grupo.find_by_identificador(id)).nil?
#            id = Array.new(2) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
#        end
#        self.identificador = id.to_s.ljust(6, "0")
#  end

  def full_description
    "#{self.identificador} | #{self.nombre}"
  end


  def liberar_clientes_con_registros_pago
    #----- Marcamos credito como pagado para liberarlo -----
    @credito = Credito.find_by_grupo_id(self.id)
    if @credito
      @credito.update_attributes!(:status => 1)
      #------- Actualizamos credito ----
      @cg = Clientegrupo.find(:all, :conditions => ["grupo_id = ?", self.id])
      @cg.each do |row|
      row.update_attributes!(:activo => false, :fecha_fin => Time.now)
      Clientegrupo.create(:cliente_id => row.cliente_id, :grupo_id => row.grupo_id, :activo => true, :fecha_inicio => Time.now )
      puts "=> Actualizado correctamente"
    end
    else
      puts "Registro no encontrado"
    end
    
  end



end
