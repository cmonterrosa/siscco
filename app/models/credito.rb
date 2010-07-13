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
  has_many :movimientos
  has_many :referencias
  has_many :pagos

    def initialize(params = nil)
    super
      self.fecha_hora = Time.now unless self.fecha_hora
     # self.user_id =  unless self.user_id
    end

    #--------- Validaciones ------
    validates_numericality_of :num_referencia, :message => "Debe de ser numero"
    validates_uniqueness_of :num_referencia,  :message => "Ya existe un credito con ese numero de referencia"


end
