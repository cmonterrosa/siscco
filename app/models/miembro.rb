class Miembro < ActiveRecord::Base
  belongs_to :jerarquia
  belongs_to :credito
  belongs_to :cliente

#  def self.fecha_hora
#    Time.now    # User.foo
#  end


  def initialize(params = nil)
    super
      self.fecha_hora = Time.now unless self.fecha_hora
      self.user_id = 1 unless self.user_id
  end

end
