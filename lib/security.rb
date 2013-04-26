# Carlos Monterrosa (cmonterrosa@gmail.com.)
require 'base64'

module Security

  def generate_token
    id = (rand(10)).to_s.rjust(2,'0') + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s.rjust(5,'1')
    Base64::encode64(id.to_s)
  end
  
  def validate_token(token)
    (Base64::decode64(token.to_s) =~  /^\d{2}[a-z]{4}\d{5}$/) ? true : false
  end

end
