require 'test_helper'

class Api::V1::ProposalsControllerTest < ActionController::TestCase
  setup do
    @proposal = proposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proposals)
  end

  test "should create proposal" do
    assert_difference('Proposal.count') do
      post :create, proposal: { description: @proposal.description, order_id: @proposal.order_id, price: @proposal.price, status: @proposal.status, user_id: @proposal.user_id }
    end

    assert_response 201
  end

  test "should show proposal" do
    get :show, id: @proposal
    assert_response :success
  end

  test "should update proposal" do
    put :update, id: @proposal, proposal: { description: @proposal.description, order_id: @proposal.order_id, price: @proposal.price, status: @proposal.status, user_id: @proposal.user_id }
    assert_response 204
  end

  test "should destroy proposal" do
    assert_difference('Proposal.count', -1) do
      delete :destroy, id: @proposal
    end

    assert_response 204
  end
end
