class Credito < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :periodo
  belongs_to :producto
  belongs_to :credito
  belongs_to :promotor
  belongs_to :grupo
  belongs_to :linea
  belongs_to :banco
  belongs_to :producto
  belongs_to :grupo
  has_many :movimientos
  has_many :referencias
  has_many :pagos

    def initialize(params = nil)
    super
      self.st = 0 unless self.st
    end

    #--------- Validaciones ------
    #before_save :grupo_unico?
    before_create :grupo_unico?
    #validates_numericality_of :num_referencia, :message => "Debe de ser numero"
    #validates_uniqueness_of :num_referencia,  :message => "Ya existe un credito con ese numero de referencia"

    def grupo_unico?
      @grupo = Grupo.find(self.grupo_id) if self.grupo_id
      sum=0

      if @grupo
         @grupo.creditos.each do |credito|
          sum+=1 if credito.status == 1
         end
         if sum > 0
          return false
         else
          return true
         end
      end
      return true
    end

    def activar
      self.status = 1
      if self.save!
        return true
      else
        return false
      end
    end

     def desactivar
      self.status = 0
      if self.save!
        return true
      else
        return false
      end
    end

     def activado?
       return true if self.status = 1
       return false if self.status != 1
     end

      def desactivado?
       return true if self.status = 1
       return false if self.status != 1
     end

   end
