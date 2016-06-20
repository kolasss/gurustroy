require 'test_helper'

class Api::V1::ProposalsControllerTest < ActionController::TestCase
  setup do
    @proposal = proposals(:proposal_one)
    @supplier = users(:supplier)
  end

  test "should get index" do
    require_login {get :index, order_id: orders(:order_one), format: :json}
    login_user @supplier
    get :index, order_id: orders(:order_one), format: :json
    assert_response :success
    assert_not_nil assigns(:proposals)
    assert_not_empty response.body
  end

  test "should create proposal" do
    require_login {post :create, order_id: orders(:order_one)}
    login_user users(:supplier3)
    assert_difference('Proposal.count') do
      post :create, order_id: orders(:order_one), proposal: {
        description: @proposal.description,
        price: @proposal.price
      }, format: :json
    end

    assert_response 201
  end

  test "should show error on create proposal" do
    login_user @supplier
    assert_no_difference('Proposal.count') do
      post :create, order_id: orders(:order_one), proposal: {
        price: @proposal.price
      }, format: :json
    end

    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should show proposal" do
    require_login {get :show, id: @proposal, format: :json}
    login_user @supplier
    get :show, id: @proposal, format: :json
    assert_response :success
    assert_not_empty response.body
  end

  test "should update proposal" do
    require_login {put :update, id: @proposal, format: :json}
    login_user @supplier
    put :update, id: @proposal, proposal: {
      description: @proposal.description,
      price: @proposal.price
    }, format: :json
    assert_response :ok
  end

  test "should show error on update proposal" do
    login_user @supplier
    put :update, id: @proposal, proposal: {
      photo_attributes: {
        file: nil
      }
    }
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should destroy proposal" do
    require_login {delete :destroy, id: @proposal}
    login_user users(:admin)
    assert_difference('Proposal.count', -1) do
      delete :destroy, id: @proposal
    end

    assert_response 204
  end

  test "should cancel proposal" do
    require_login {delete :cancel, id: @proposal}
    login_user @supplier
    delete :cancel, id: @proposal

    assert_response 204
  end
end
