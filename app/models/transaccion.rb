class Transaccion < ActiveRecord::Base
belongs_to :pago
belongs_to :tipo_transaccion
end
