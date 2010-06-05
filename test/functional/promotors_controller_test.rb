require File.dirname(__FILE__) + '/../test_helper'
require 'promotors_controller'

# Re-raise errors caught by the controller.
class PromotorsController; def rescue_action(e) raise e end; end

class PromotorsControllerTest < Test::Unit::TestCase
  fixtures :promotors

  def setup
    @controller = PromotorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = promotors(:first).id
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

    assert_not_nil assigns(:promotors)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:promotor)
    assert assigns(:promotor).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:promotor)
  end

  def test_create
    num_promotors = Promotor.count

    post :create, :promotor => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_promotors + 1, Promotor.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:promotor)
    assert assigns(:promotor).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Promotor.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Promotor.find(@first_id)
    }
  end
end
