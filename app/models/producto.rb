class Producto < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :periodo
  has_many :creditos

  def initialize(params = nil)
    super
      self.moratorio = self.intereses.to_f * 2.0 unless self.moratorio
    end

end
