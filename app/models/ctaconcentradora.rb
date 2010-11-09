class Ctaconcentradora < ActiveRecord::Base
  belongs_to :sucbancaria
  belongs_to :cuenta
  has_many :lineas

  def descripcion
    self.sucbancaria.descripcion + "-#{num_cta}"
  end

end
