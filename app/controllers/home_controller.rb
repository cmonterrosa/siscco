class HomeController < ApplicationController
  before_filter :login_required, :except =>[ :index]
  if $usuario.empty?
    layout 'inicio'
  else
    layout 'contenido'
  end

  def index
  end
end
