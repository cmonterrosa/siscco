class Grupo < ActiveRecord::Base
  has_and_belongs_to_many :clientes
  has_many :productos
  has_many :creditos
  #---- relacion ficticia -----
   has_many :clientegrupos
end
