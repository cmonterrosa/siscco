require File.dirname(__FILE__) + '/../test_helper'
require 'administracion_controller'

# Re-raise errors caught by the controller.
class AdministracionController; def rescue_action(e) raise e end; end

class AdministracionControllerTest < Test::Unit::TestCase
  def setup
    @controller = AdministracionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
