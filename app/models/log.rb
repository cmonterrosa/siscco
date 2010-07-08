class Log < ActiveRecord::Base
   def initialize(params = nil)
    super
      self.fecha_hora = Time.now unless self.fecha_hora
      self.user_id = 1 unless self.user_id
    end
end
