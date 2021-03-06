require File.dirname(__FILE__) + '/../test_helper'
require 'creditos_controller'

# Re-raise errors caught by the controller.
class CreditosController; def rescue_action(e) raise e end; end

class CreditosControllerTest < Test::Unit::TestCase
  fixtures :creditos

  def setup
    @controller = CreditosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = creditos(:first).id
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

    assert_not_nil assigns(:creditos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:credito)
    assert assigns(:credito).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:credito)
  end

  def test_create
    num_creditos = Credito.count

    post :create, :credito => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_creditos + 1, Credito.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:credito)
    assert assigns(:credito).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Credito.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Credito.find(@first_id)
    }
  end
end
