require File.dirname(__FILE__) + '/../test_helper'
require 'bancos_controller'

# Re-raise errors caught by the controller.
class BancosController; def rescue_action(e) raise e end; end

class BancosControllerTest < Test::Unit::TestCase
  fixtures :bancos

  def setup
    @controller = BancosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = bancos(:first).id
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

    assert_not_nil assigns(:bancos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:banco)
    assert assigns(:banco).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:banco)
  end

  def test_create
    num_bancos = Banco.count

    post :create, :banco => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_bancos + 1, Banco.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:banco)
    assert assigns(:banco).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Banco.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Banco.find(@first_id)
    }
  end
end
