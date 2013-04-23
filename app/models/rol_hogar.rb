class RolHogar < ActiveRecord::Base
  has_many :clientes

  def roless
    "#{rol} - #{id}"
  end
  
end
