class Sucbancaria < ActiveRecord::Base
  belongs_to :banco
  has_many :ctaconcentradoras
  has_many :ctaliquidadoras

  def descripcion
    self.banco.nombre.to_s + "-#{num_sucursal}"
  end


end
