class Vivienda < ActiveRecord::Base
  has_many :clientes
end
