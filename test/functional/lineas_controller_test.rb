require File.dirname(__FILE__) + '/../test_helper'
require 'lineas_controller'

# Re-raise errors caught by the controller.
class LineasController; def rescue_action(e) raise e end; end

class LineasControllerTest < Test::Unit::TestCase
  fixtures :lineas

  def setup
    @controller = LineasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = lineas(:first).id
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

    assert_not_nil assigns(:lineas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:linea)
    assert assigns(:linea).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:linea)
  end

  def test_create
    num_lineas = Linea.count

    post :create, :linea => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_lineas + 1, Linea.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:linea)
    assert assigns(:linea).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Linea.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Linea.find(@first_id)
    }
  end
end
