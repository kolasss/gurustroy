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
    assert_not_nil assigns(:categories_version)
    assert_not_nil assigns(:categories)
    assert_not_empty response.body
  end

  test "should search by tags in index" do
    login_user @admin
    tag = tags(:molotok)
    get :index, q: tag.name, format: :json
    assert_response :success
    assert_not_nil assigns(:categories)
    assert_match tag.category.name, response.body
  end

  test "should create category" do
    require_login {post :create, format: :json}
    login_user @admin
    assert_difference('Category.count') do
      post :create, category: { name: "Новая категория" }, format: :json
    end

    assert_response 201
  end

  test "should show error on create category" do
    login_user @admin
    assert_no_difference('Category.count') do
      post :create, category: { name: nil }, format: :json
    end

    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should update category" do
    require_login {put :update, id: @category, format: :json}
    login_user @admin
    put :update, id: @category, category: { name: @category.name }, format: :json
    assert_response :ok
  end

  test "should show error on update category" do
    login_user @admin
    put :update, id: @category, category: { name: nil }
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
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
