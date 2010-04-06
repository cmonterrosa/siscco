
require 'digest/sha1'
class User < ActiveRecord::Base

  belongs_to :rol

  

  def self.authenticate(login, pass)
    find(:first, :conditions => ["login = ? AND password = ?", login, sha1(pass)])
  end

  def self.autenticar(login,pass)
      find(:first, :conditions => ["login = ? AND password = ?", login, sha1(pass)])
  end

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end

  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end

  before_create :crypt_password

  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end

  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation
  validates_uniqueness_of :login, :on => :create, :message => "ese usuario ya existe"
  validates_confirmation_of :password, :on => :create

end
