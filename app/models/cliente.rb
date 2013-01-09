class Cliente < ActiveRecord::Base
  belongs_to :civil
  belongs_to :escolaridad
  belongs_to :vivienda
  belongs_to :localidad
  belongs_to :edo_residencia
  belongs_to :nacionalidad
  belongs_to :rol_hogar
  has_and_belongs_to_many :grupos
  has_many :negocios
  has_many :creditos
  has_many :pagos
  has_many :miembros
  #--- relacion ficticia ---
  has_many :clientegrupos

   def initialize(params = nil)
    super
      self.st = 1 unless self.st
      self.nacionalidad_id = 140 unless self.nacionalidad_id #-- Mexico por defecto ----
      self.fecha_captura = Time.now unless self.fecha_captura
    end

  def nombre_completo
    "#{paterno} #{materno} #{nombre}"
  end


#------- Validaciones -----------
#validates_uniqueness_of :rfc, :message => ", Ese cliente ya esta registrado."
#validates_uniqueness_of :identificador, :message => ", Ese cliente ya esta registrado."
validates_uniqueness_of :curp, :message => ", Ese cliente ya esta registrado."
validates_length_of :rfc, :in => 10..13,  :message => ", Longitud incorrecta"
validates_length_of :curp, :is => 18,  :message => ", Longitud incorrecta"
#validates_associated :grupos, :message => "existen registros en otras tablas"


  def destroy
    #self.st=0
    #self.save!
    super
    unless self.clientegrupos.empty?
      self.clientegrupos.each do |clientegrupo|
        clientegrupo.activo=0
        clientegrupo.save!
      end
    end
  end

  def generar_id!
    id = Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
    while not (Cliente.find_by_identificador(id)).nil?
      id = Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
    end
    self.identificador = id.to_s.ljust(8, "0")
    self.save!
  end

  def generar_id_faltantes
    clientes = Cliente.find(:all, :conditions => ["identificador is NULL"])
    clientes.each{|c|
      id = Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
      while not (Cliente.find_by_identificador(id)).nil?
        id = Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
      end
      c.update_attributes!(:identificador => id.to_s.ljust(8, "0"))
    }
  end

end
