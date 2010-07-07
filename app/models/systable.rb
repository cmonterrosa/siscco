class Systable < ActiveRecord::Base
  belongs_to :rol
  belongs_to :controller
end
