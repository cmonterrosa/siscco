class Linea < ActiveRecord::Base
  belongs_to :fondeo
  has_many :pagoslineas
end
