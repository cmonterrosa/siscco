class HomeController < ApplicationController
  before_filter :login_required, :except =>[ :index]
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
