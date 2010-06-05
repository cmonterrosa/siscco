class Ejido < ActiveRecord::Base
belongs_to :municipio
has_many :colonias
end
