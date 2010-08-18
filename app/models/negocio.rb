class Negocio < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :actividad
end
