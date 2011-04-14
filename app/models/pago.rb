class Pago < ActiveRecord::Base
  belongs_to :credito
  belongs_to :cliente
end
