class Ctaconcentradora < ActiveRecord::Base
  belongs_to :sucbancaria
  has_many :lineas
end
