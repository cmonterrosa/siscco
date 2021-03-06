class Credito < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :periodo
  belongs_to :producto
  belongs_to :credito
  belongs_to :promotor
  belongs_to :grupo
  belongs_to :linea
  #belongs_to :banco
  belongs_to :destino
  belongs_to :grupo
  has_many :movimientos
  has_many :referencias
  has_many :pagos
  has_many :miembros
  has_many :devengos
  has_many :depositos
  has_many :excedentes

    def initialize(params = nil)
    super
      self.status = 0 unless self.status
      self.identificador = (rand(10)).to_s + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s unless self.identificador
      self.fecha_captura = Time.now unless self.fecha_captura
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

  def ultimo_pago
      num_pago = Pagogrupal.maximum(:num_pago, :conditions => ["credito_id=?", self.id])
      @pago = Pagogrupal.find(:first, :conditions => ["credito_id = ? and num_pago = ?", self.id, num_pago])
      if @pago
        return @pago.fecha_limite
      else
        return "--"
      end
  end


  def tasa_moratoria
    moratorio=0.0
        if self.tipo_interes == "SALDOS INSOLUTOS (SSI)"
          if self.producto.moratorio_ssi
            moratorio=self.producto.moratorio_ssi
          else
            moratorio = ((self.producto.tasa_anualizada.to_f * 2))
          end
        else
          if self.producto.moratorio_flat
             moratorio = self.producto.moratorio_flat.to_f
          else
             moratorio = (self.producto.moratorio_flat.to_f * 2)
          end
        end
        return moratorio
  end

  def liquidado?
    if self.status==1
      return true
    else
      return false
    end
  end


  def presidente
     jerarquia = Jerarquia.find_by_jerarquia("presidente")
     return (Miembro.find(:first, :conditions => ["credito_id = ? AND jerarquia_id = ?", self.id, jerarquia.id])).cliente
  end

   end
