# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  layout 'contenido'
  
  require 'date'
  require "#{RAILS_ROOT}/lib/tareas.rb"

  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  include Variables
  include Utilerias
  include Databases
  include Creditos
  include SendDocHelper

  include Security

  helper :send_doc
  helper :all # include all helpers, all the time

  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  #--- combo de semanas, maximo 52 ----
  @semanas = []
  (1..52).each do |x| @semanas << x end
  $semanas = @semanas

  #--- Constantes --
   #------ Configuracion -----
  @conf ||= Configuracion.find(:first, :conditions => "activo = 1")
  CIUDAD_EMPRESA = @conf.ciudad
  NOMBRE_EMPRESA = @conf.nombre_empresa
  DIRECCION_EMPRESA = @conf.direccion
  TELEFONO_EMPRESA = @conf.telefono
  SUCURSAL = "SOCAMA CENTRO FRAYLESCA A.C"
end
