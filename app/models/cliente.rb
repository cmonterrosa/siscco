class Cliente < ActiveRecord::Base
  belongs_to :civil
  belongs_to :escolaridad
  belongs_to :vivienda
  belongs_to :colonia
  belongs_to :nacionalidad
  has_and_belongs_to_many :grupos
  has_many :negocios
  has_many :creditos
  has_many :pagos
  #--- relacion ficticia ---
  has_many :clientegrupos

   def initialize(params = nil)
    super
      self.st = 1 unless self.st
    end


  def nombre_completo
    "#{paterno} #{materno} #{nombre}"
  end

#------- Validaciones -----------
validates_uniqueness_of :rfc, :message => ", Ese cliente ya esta registrado."
validates_uniqueness_of :curp, :message => ", Ese cliente ya esta registrado."
validates_length_of :rfc, :in => 10..13,  :message => ", Longitud incorrecta"
validates_length_of :curp, :is => 18,  :message => ", Longitud incorrecta"
#validates_associated :grupos, :message => "existen registros en otras tablas"


  def validates_grupo
    grupos = Grupo.find(:all)
  end

  def destroy
    self.st=0
    self.save!
    unless self.clientegrupos.empty?
      self.clientegrupos.each do |clientegrupo|
        clientegrupo.activo=0
        clientegrupo.save!
      end
    end
  end
   
end
