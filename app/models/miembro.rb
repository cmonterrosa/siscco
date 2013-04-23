class Miembro < ActiveRecord::Base
  belongs_to :jerarquia
  belongs_to :credito
  belongs_to :cliente
end
