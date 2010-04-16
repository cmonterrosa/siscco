class Credito < ActiveRecord::Base
  belongs_to :cliente
  has_many :movimientos
  has_many :referencias
end
