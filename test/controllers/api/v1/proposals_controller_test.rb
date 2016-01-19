require 'test_helper'

class Api::V1::ProposalsControllerTest < ActionController::TestCase
  setup do
    @proposal = proposals(:proposal_one)
    login_user users(:supplier)
  end

  test "should get index" do
    get :index, order_id: orders(:order_one)
    assert_response :success
    assert_not_nil assigns(:proposals)
  end

  test "should create proposal" do
    assert_difference('Proposal.count') do
      post :create, order_id: orders(:order_one), proposal: {
        description: @proposal.description,
        price: @proposal.price
      }
    end

    assert_response 201
  end

  test "should show proposal" do
    get :show, id: @proposal
    assert_response :success
  end

  test "should update proposal" do
    put :update, id: @proposal, proposal: {
      description: @proposal.description,
      price: @proposal.price
    }
    assert_response 204
  end

  test "should destroy proposal" do
    login_user users(:admin)
    assert_difference('Proposal.count', -1) do
      delete :destroy, id: @proposal
    end

    assert_response 204
  end

  test "should cancel proposal" do
    get :cancel, id: @proposal

    assert_response 204
  end
end
