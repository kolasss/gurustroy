require 'test_helper'

class Api::V1::OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:order_one)
    login_user users(:customer)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: {
        category_id: @order.category_id,
        description: @order.description,
        price: @order.price,
        quantity: @order.quantity,
        unit_id: @order.unit_id
      }, format: :json
    end

    assert_response 201
  end

  test "should show order" do
    get :show, id: @order, format: :json
    assert_response :success
  end

  test "should update order" do
    put :update, id: @order, order: {
      category_id: @order.category_id,
      description: @order.description,
      price: @order.price,
      quantity: @order.quantity,
      unit_id: @order.unit_id
    }
    assert_response 204
  end

  test "should destroy order" do
    login_user users(:admin)
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_response 204
  end

  test "should cancel order" do
    get :cancel, id: @order
    assert_response 204
  end

  test "should finish order" do
    get :finish, id: @order, proposal_id: @order.proposals.first
    assert_response 204
  end
end
