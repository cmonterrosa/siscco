# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  layout 'contenido'
  
  require 'date'

  include AuthenticatedSystem
  include Variables
  include Utilerias
  include Databases
  include Creditos
  include SendDocHelper

  helper :send_doc
  helper :all # include all helpers, all the time

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
