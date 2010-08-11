class Colonia < ActiveRecord::Base
  has_many :sucursales
  belongs_to :ejido
end
