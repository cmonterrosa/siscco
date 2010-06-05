class CatalogosController < ApplicationController
  layout 'contenido'
  before_filter :permiso_requerido
 


  def index

  end
end
