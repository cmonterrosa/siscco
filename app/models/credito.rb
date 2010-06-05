class Credito < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :periodo
  belongs_to :producto
  belongs_to :credito
  belongs_to :promotor
  has_many :movimientos
  has_many :referencias
  has_many :pagos
end
