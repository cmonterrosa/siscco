class Cliente < ActiveRecord::Base
  belongs_to :civil
  belongs_to :escolaridad
  belongs_to :vivienda
  belongs_to :colonia
  belongs_to :grupo
  has_many :negocios
  has_many :creditos
  has_many :pagos

  def nombre_completo
    "#{paterno} #{materno} #{nombre}"
  end

end
