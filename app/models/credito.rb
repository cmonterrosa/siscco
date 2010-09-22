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
  has_many :miembros

    def initialize(params = nil)
    super
      self.status = 0 unless self.status
      self.identificador = (rand(10)).to_s + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s unless self.identificador
    end

    #--------- Validaciones ------
    #before_save :grupo_unico?
    #before_create :grupo_unico?
    #validates_numericality_of :num_referencia, :message => "Debe de ser numero"
    #validates_uniqueness_of :num_referencia,  :message => "Ya existe un credito con ese numero de referencia"
    #validates_uniqueness_of :identificador, :message => ", Ese cliente ya esta registrado."

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
       return true if self.status == 1
       return false if self.status != 1
     end

      def desactivado?
       return true if self.status == 0
       return false if self.status != 1
     end


  def generar_id!
    id = (rand(10)).to_s + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
    if Credito.find_by_identificador(id)
       id = (rand(10)).to_s Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
    end
    self.identificador = id
    self.save!
  end


   end
