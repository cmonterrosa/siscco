class Banco < ActiveRecord::Base
  belongs_to :colonia
  has_many :creditos
#  has_many   :lineas
  def banco_cuenta
    "#{nombre} - #{num_cuenta}"
  end
#  validates_presence_of :nu_cuenta
#  validates_numericality_of :num_cuenta, :message => 'El valor del Num Cuenta no es digito'

end
