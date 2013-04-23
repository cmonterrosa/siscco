class Negocio < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :actividad
  belongs_to :ubicacion_negocio
end
