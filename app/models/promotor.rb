class Promotor < ActiveRecord::Base
  has_many :creditos
  belongs_to :sucursal

  def nombre_completo
    "#{paterno} #{materno} #{nombre}"
  end

  def nombre_completo_desc
    "#{nombre} #{paterno} #{materno}"
  end
  #validates_format_of :email, :with =>/\A([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})\Z/i, :message => "Campo Email no válido"

end
