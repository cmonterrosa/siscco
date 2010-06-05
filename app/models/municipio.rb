class Municipio < ActiveRecord::Base
  belongs_to :estado
  has_many :ejidos
end
