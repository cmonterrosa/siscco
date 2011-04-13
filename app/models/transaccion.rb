class Transaccion < ActiveRecord::Base
belongs_to :pagogrupal
belongs_to :tipo_transaccion
belongs_to :datafile
end
