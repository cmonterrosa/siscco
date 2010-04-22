class Banco < ActiveRecord::Base
  belongs_to :colonia
  def banco_cuenta
    "#{nombre} - #{num_cuenta}"
  end
end
