class Periodo < ActiveRecord::Base
  has_many :productos
  has_many :creditos
end
