class Producto < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :periodo
end
