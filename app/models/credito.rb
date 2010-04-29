class Credito < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :periodo
  belongs_to :producto
  has_many :movimientos
  has_many :referencias
end
