class Banco < ActiveRecord::Base
  belongs_to :colonia
  def banco_cuenta
    "#{nombre} - #{num_cuenta}"
  end
#  validates_presence_of :nu_cuenta
#  validates_numericality_of :num_cuenta, :message => 'El valor del Num Cuenta no es digito'

end
