class Pago < ActiveRecord::Base
  has_many :movimientos
  belongs_to :credito
end
