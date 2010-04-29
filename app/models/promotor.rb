class Promotor < ActiveRecord::Base
  def nombre_completo
    "#{paterno} #{materno} #{nombre}"
  end
end
