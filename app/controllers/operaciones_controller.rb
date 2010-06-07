class OperacionesController < ApplicationController
  before_filter :login_required, :except =>[ :index]
  layout 'inicio'

  def index

  end
end
