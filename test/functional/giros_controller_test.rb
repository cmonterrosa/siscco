require File.dirname(__FILE__) + '/../test_helper'
require 'giros_controller'

# Re-raise errors caught by the controller.
class GirosController; def rescue_action(e) raise e end; end

class GirosControllerTest < Test::Unit::TestCase
  fixtures :giros

  def setup
    @controller = GirosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = giros(:first).id
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

    assert_not_nil assigns(:giros)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:giro)
    assert assigns(:giro).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:giro)
  end

  def test_create
    num_giros = Giro.count

    post :create, :giro => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_giros + 1, Giro.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:giro)
    assert assigns(:giro).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Giro.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Giro.find(@first_id)
    }
  end
end
