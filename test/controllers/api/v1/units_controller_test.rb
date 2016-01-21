require 'test_helper'

class Api::V1::UnitsControllerTest < ActionController::TestCase
  setup do
    @unit = units(:bez_orderov)
    login_user users(:admin)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:units)
  end

  test "should create unit" do
    assert_difference('Unit.count') do
      post :create, unit: { name: "Новая еденица" }, format: :json
    end

    assert_response 201
  end

  test "should update unit" do
    put :update, id: @unit, unit: { name: @unit.name }
    assert_response 204
  end

  test "should destroy unit" do
    assert_difference('Unit.count', -1) do
      delete :destroy, id: @unit
    end

    assert_response 204
  end
end
