require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:customer)
    @admin = users(:admin)
  end

  test "should get index" do
    require_login {get :index, format: :json}
    login_user @admin
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should show user" do
    require_login {get :show, id: @user, format: :json}
    login_user @admin
    get :show, id: @user, format: :json
    assert_response :success
  end

  test "should create user" do
    require_login {post :create, format: :json}
    login_user @admin
    assert_difference('User.count') do
      post :create, user: {
        company: @user.company,
        name: @user.name,
        phone: "79011231212",
        type: @user.type
      }, format: :json
    end

    assert_response 201
  end

  test "should show error on create user" do
    login_user @admin
    assert_no_difference('User.count') do
      post :create, user: {
        company: @user.company,
        name: @user.name
      }, format: :json
    end

    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should update user" do
    require_login {put :update, id: @user}
    login_user @admin
    put :update, id: @user, user: {
      company: @user.company,
      name: @user.name,
      phone: @user.phone,
      type: @user.type
    }
    assert_response 204
  end

  test "should show error on update user" do
    login_user @admin
    put :update, id: @user, user: {
      phone: nil
    }
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should destroy user" do
    @user = users(:new_customer)
    require_login {delete :destroy, id: @user}
    login_user @admin
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_response 204
  end

  test "should show error on destroy user" do
    login_user @admin
    assert_no_difference('User.count') do
      delete :destroy, id: @user
    end

    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should get orders" do
    require_login {get :orders, id: @user, format: :json}
    login_user @admin
    get :orders, id: @user, format: :json
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get proposals" do
    @user = users(:supplier)
    require_login {get :proposals, id: @user, format: :json}
    login_user @admin
    get :proposals, id: @user, format: :json
    assert_response :success
    assert_not_nil assigns(:proposals)
  end

  test "should get change_type" do
    require_login {get :change_type, id: @user, user_type: 'Admin', format: :json}
    login_user @admin
    get :change_type, id: @user, user_type: 'Admin', format: :json
    assert_response :success
  end
end
