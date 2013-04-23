class HomeController < ApplicationController
  before_filter :login_required

#  if $usuario
#    layout 'contenido'
#  else
#    layout 'inicio'
#  end

  def index
  end
  #----- Menús dinamicos -----
  def display_catalogos
    render :layout => false
  end
  def display_reportes
    render :layout => false
  end
  




end
