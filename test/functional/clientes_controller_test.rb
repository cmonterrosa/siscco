require File.dirname(__FILE__) + '/../test_helper'
require 'clientes_controller'

# Re-raise errors caught by the controller.
class ClientesController; def rescue_action(e) raise e end; end

class ClientesControllerTest < Test::Unit::TestCase
  fixtures :clientes

  def setup
    @controller = ClientesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = clientes(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:clientes)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:cliente)
    assert assigns(:cliente).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:cliente)
  end

  def test_create
    num_clientes = Cliente.count

    post :create, :cliente => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_clientes + 1, Cliente.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:cliente)
    assert assigns(:cliente).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Cliente.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Cliente.find(@first_id)
    }
  end
end
