class Pago < ActiveRecord::Base
  has_many :movimientos
  belongs_to :credito
  belongs_to :cliente
end
