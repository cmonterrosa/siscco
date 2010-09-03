class Sucursal < ActiveRecord::Base
belongs_to :colonia
has_many :promotors
end
