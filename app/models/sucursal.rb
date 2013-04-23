class Sucursal < ActiveRecord::Base
belongs_to :municipio
has_many :promotors
end
