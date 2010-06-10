class HomeController < ApplicationController
  before_filter :login_required, :except =>[ :index]
  if $usuario.nil?
    layout 'inicio'
  else
    layout 'contenido'
  end

  def index
  end
end
