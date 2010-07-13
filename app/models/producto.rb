class Producto < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :periodo
  has_many :creditos
end
