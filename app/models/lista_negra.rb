class ListaNegra < ActiveRecord::Base

  def nombre_completo
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end
end
