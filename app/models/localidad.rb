class Localidad < ActiveRecord::Base
has_many :clientes
belongs_to :municipio
end
