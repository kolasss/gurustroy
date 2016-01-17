require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:customer)
    login_user users(:customer)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
        company: @user.company,
        name: @user.name,
        phone: "334234",
        type: @user.type
      }
    end

    assert_response 201
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { company: @user.company, name: @user.name, phone: @user.phone, type: @user.type }
    assert_response 204
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_response 204
  end
end
