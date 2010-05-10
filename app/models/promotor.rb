class Promotor < ActiveRecord::Base
  def nombre_completo
    "#{paterno} #{materno} #{nombre}"
  end
  validates_format_of :email, :with =>/\A([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})\Z/i, :message => "Campo Email no válido"

end
