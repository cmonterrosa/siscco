require File.dirname(__FILE__) + '/../test_helper'
require 'festivos_controller'

# Re-raise errors caught by the controller.
class FestivosController; def rescue_action(e) raise e end; end

class FestivosControllerTest < Test::Unit::TestCase
  fixtures :festivos

  def setup
    @controller = FestivosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = festivos(:first).id
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

    assert_not_nil assigns(:festivos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:festivo)
    assert assigns(:festivo).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:festivo)
  end

  def test_create
    num_festivos = Festivo.count

    post :create, :festivo => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_festivos + 1, Festivo.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:festivo)
    assert assigns(:festivo).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Festivo.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Festivo.find(@first_id)
    }
  end
end
