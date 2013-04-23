class Referencia < ActiveRecord::Base
  has_and_belogs_to_many :garantias
  belongs_to :credito
end
