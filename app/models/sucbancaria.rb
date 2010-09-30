class Sucbancaria < ActiveRecord::Base
  belongs_to :banco
  has_many :ctaconcentradoras
  has_many :ctaliquidadoras
end
