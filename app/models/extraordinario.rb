class Extraordinario < ActiveRecord::Base
  belongs_to :credito

    def initialize(params = nil)
    super
      self.status = 0 unless self.status
    end

end
