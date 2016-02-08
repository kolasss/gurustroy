require 'test_helper'

class Api::V1::CategoriesControllerTest < ActionController::TestCase
  setup do
    @category = categories(:bez_orderov)
    @admin = users(:admin)
  end

  test "should get index" do
    require_login {get :index, format: :json}
    login_user @admin
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should create category" do
    require_login {post :create, format: :json}
    login_user @admin
    assert_difference('Category.count') do
      post :create, category: { name: "Новая категория" }, format: :json
    end

    assert_response 201
  end

  test "should update category" do
    require_login {put :update, id: @category}
    login_user @admin
    put :update, id: @category, category: { name: @category.name }
    assert_response 204
  end

  test "should destroy category" do
    require_login {delete :destroy, id: @category}
    login_user @admin
    assert_difference('Category.count', -1) do
      delete :destroy, id: @category
    end

    assert_response 204
  end
end
