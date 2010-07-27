class Clientegrupo < ActiveRecord::Base
  set_table_name "clientes_grupos"
  belongs_to :cliente
  belongs_to :grupo

     def initialize(params = nil)
    super
      self.activo = 1 unless self.activo
      self.fecha_inicio = Time.now unless self.fecha_inicio
    end

     def desactivar
        self.st=0
        self.fecha_fin = Time.now
        self.save!
     end
end
