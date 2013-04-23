class Fechavalor < ActiveRecord::Base
  belongs_to :datafile
  belongs_to :credito
  
    def initialize(params = nil)
    super
      self.fecha_hora = Time.now unless self.fecha_hora
      self.st = "NA" unless self.st
      self.tipo = "NORMAL" unless self.tipo
    end
end
