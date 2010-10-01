class Ctaliquidadora < ActiveRecord::Base
  belongs_to :sucbancaria
  has_many :lineas
  def descripcion
    self.sucbancaria.descripcion + "-#{num_cta}"
  end

end
