require File.dirname(__FILE__) + '/../test_helper'
require 'banco_controller'

# Re-raise errors caught by the controller.
class BancoController; def rescue_action(e) raise e end; end

class BancoControllerTest < Test::Unit::TestCase
  def setup
    @controller = BancoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
