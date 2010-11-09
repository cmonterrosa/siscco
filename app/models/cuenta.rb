class Cuenta < ActiveRecord::Base
  has_many :polizas
  has_many :ctaconcentradoras
  has_many :ctaliquidadoras
end
