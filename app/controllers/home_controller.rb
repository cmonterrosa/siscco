class HomeController < ApplicationController
before_filter :login_required, :except =>[ :index]
layout 'contenido'

  def index
  end
end
