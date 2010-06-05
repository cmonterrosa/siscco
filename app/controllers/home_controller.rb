class HomeController < ApplicationController
before_filter :login_required, :except =>[ :index]
layout 'logged'

  def index
  end
end
