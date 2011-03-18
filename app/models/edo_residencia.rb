class EdoResidencia < ActiveRecord::Base
  set_table_name "estados"
  has_many :clientes

end
