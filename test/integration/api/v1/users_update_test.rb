require 'test_helper'

class UsersUpdateTest < ActionDispatch::IntegrationTest

  test "change user's type as admin" do
    admin = users(:admin)
    user = users(:supplier)
    headers = auth_header admin
    new_type = 'Customer'
    put "/api/v1/users/#{user.id}/change_type", {
        user_type: new_type
      }, headers
    assert_response :success
    # checking
    get "/api/v1/users/#{user.id}", nil, headers
    assert_match user.name, response.body
    assert_match new_type, response.body
  end

  test "change user's type as another user" do
    first_user = users(:supplier)
    second_user = users(:customer)
    headers = auth_header second_user
    new_type = 'Customer'
    put "/api/v1/users/#{first_user.id}/change_type", {
        user_type: new_type
      }, headers
    assert_response :forbidden
    # checking
    get "/api/v1/users/#{first_user.id}", nil, headers
    assert_match first_user.name, response.body
    assert_no_match new_type, response.body
  end

  test "change user's own type" do
    user = users(:supplier)
    headers = auth_header user
    new_type = 'Customer'
    put "/api/v1/users/change_my_type", {
        user_type: new_type
      }, headers
    assert_response :success
    # checking
    get "/api/v1/users/#{user.id}", nil, headers
    assert_match user.name, response.body
    assert_match new_type, response.body
  end

  test "change user's own type to admin" do
    user = users(:supplier)
    headers = auth_header user
    new_type = 'Admin'
    put "/api/v1/users/change_my_type", {
        user_type: new_type
      }, headers
    assert_response :unprocessable_entity
    # checking
    get "/api/v1/users/#{user.id}", nil, headers
    assert_match user.name, response.body
    assert_no_match new_type, response.body
  end
end
