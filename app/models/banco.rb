class Banco < ActiveRecord::Base
  belongs_to :municipio
  #has_many :creditos
  has_many :sucbancarias
#  has_many   :lineas

  def banco_cuenta
    "#{nombre} - #{num_cuenta}"
  end

end
