require 'test_helper'

class Api::V1::UnitsControllerTest < ActionController::TestCase
  setup do
    @unit = units(:bez_orderov)
    @admin = users(:admin)
  end

  test "should get index" do
    require_login {get :index, format: :json}
    login_user @admin
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:units_version)
    assert_not_nil assigns(:units)
    assert_not_empty response.body
  end

  test "should create unit" do
    require_login {post :create, format: :json}
    login_user @admin
    assert_difference('Unit.count') do
      post :create, unit: { name: "Новая еденица" }, format: :json
    end

    assert_response 201
  end

  test "should show error on create unit" do
    login_user @admin
    assert_no_difference('Unit.count') do
      post :create, unit: { name: nil }, format: :json
    end

    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should update unit" do
    require_login {put :update, id: @unit, format: :json}
    login_user @admin
    put :update, id: @unit, unit: { name: @unit.name }, format: :json
    assert_response :ok
  end

  test "should show error on update unit" do
    login_user @admin
    put :update, id: @unit, unit: { name: nil }
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should destroy unit" do
    require_login {delete :destroy, id: @unit}
    login_user @admin
    assert_difference('Unit.count', -1) do
      delete :destroy, id: @unit
    end

    assert_response 204
  end

  test "should show error on destroy unit" do
    login_user @admin
    unit = units(:shtyki)
    assert_no_difference('Unit.count', -1) do
      delete :destroy, id: unit
    end

    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end
end
