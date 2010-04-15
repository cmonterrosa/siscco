class CatalogosController < ApplicationController
  before_filter :permiso_requerido
  layout 'logged'


  def index

  end
end
