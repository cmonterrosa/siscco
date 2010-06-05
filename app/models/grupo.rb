class Grupo < ActiveRecord::Base
  has_many :clientes
  has_many :productos
  has_many :creditos
end
