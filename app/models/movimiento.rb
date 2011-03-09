class Movimiento < ActiveRecord::Base
  belongs_to :credito
  belongs_to :pago
end

#no se usaaaa