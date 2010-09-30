class Linea < ActiveRecord::Base
  belongs_to :ctalquidadora
  belongs_to :ctaconcentradora
  belongs_to :fondeo
  has_many :pagoslineas
  has_many :creditos
end
