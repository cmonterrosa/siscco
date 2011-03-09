class Pagogrupal < ActiveRecord::Base
  belongs_to :credito
  has_many :transaccions
end
