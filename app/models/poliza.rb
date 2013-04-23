class Poliza < ActiveRecord::Base
belongs_to :cuenta

  def initialize(params = nil)
    super
      self.tipo_poliza = 1 unless self.tipo_poliza #--- Poliza de Diario
  end
end
