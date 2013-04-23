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

end
