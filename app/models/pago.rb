class Pago < ActiveRecord::Base
  has_many :movimientos
  belongs_to :credito
  belongs_to :cliente


  def initialize(params = nil)
    super
      self.comisiones = "0" unless self.comisiones
      self.iva_comisiones = "0" unless self.iva_comisiones
      self.iva_moratorio = "0" unless self.iva_moratorio
      self.moratorio = "0" unless self.moratorio
  end
end
