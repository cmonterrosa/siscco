class Fondeo < ActiveRecord::Base
 has_many :lineas
 #------ Validaciones ------
 validates_uniqueness_of :acronimo, :message => ", Ese acronimo ya esta registrado"
  validates_uniqueness_of :fuente, :message => ", Esa fuente ya esta registrada"
end
