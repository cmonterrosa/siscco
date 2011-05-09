class Deposito < ActiveRecord::Base
  belongs_to :datafile
  belongs_to :credito

  alidates_format_of :fecha, :with => /\d{4}\/\d{2}\/\d{4}/, :message => "formato de fecha: aaaa/mm/dd"
  
    def initialize(params = nil)
    super
      self.fecha_hora = Time.now unless self.fecha_hora
      self.st = "NA" unless self.st
   end
end
