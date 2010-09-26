class HomeController < ApplicationController
  before_filter :login_required, :except =>[ :index]

  #---- Incluimos las Variables Globales ---
  include Variables
  #---- Incluimos las utilerias
  include Utilerias
  #---- Incluimos Base de Datos ---
  include Databases

  def index
  end
end
