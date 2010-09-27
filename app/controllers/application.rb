class ApplicationController < ActionController::Base
  require 'date'
  # --- Plantilla por defecto ------
  layout 'contenido'

  # ---  Incluimos la libreria para el acceso ---
  include LoginSystem
  model :user

  #---- Incluimos las Variables Globales ---
  include Variables
  #---- Incluimos las utilerias
  include Utilerias
  #---- Incluimos Base de Datos ---
  include Databases
  #--- Incluimos la clase para generar los reportes ----
  helper :send_doc
  include SendDocHelper
  before_filter :configure_charsets
  def configure_charsets
   headers["Content-Type"] = "text/html; charset=UTF-8"
  end
  filter_parameter_logging :password
end

# ---- Personalizacion de las clases ----
class ActiveRecord::RecordInvalid
  def initialize(record)
      @record = record
      super("Verifique el campo: #{@record.errors.full_messages.join(", ")}")
  end
end



