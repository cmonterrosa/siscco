class Linea < ActiveRecord::Base
  belongs_to :fondeo
  belongs_to :banco
  has_many :pagoslineas
  has_many :creditos
end
