class Banco < ActiveRecord::Base
  belongs_to :colonia
  has_many :creditos
#  has_many   :lineas

  def banco_cuenta
    "#{nombre} - #{num_cuenta}"
  end

end
