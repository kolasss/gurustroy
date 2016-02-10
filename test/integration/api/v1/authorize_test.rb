require 'test_helper'

class AuthorizeTest < ActionDispatch::IntegrationTest

  test 'try to destroy category with orders' do
    user = users(:supplier)
    admin = users(:admin)
    category = categories(:instrumenti)

    # with out admin rights
    delete "/api/v1/categories/#{category.id}"
    assert_response :unauthorized
    headers = auth_header user
    delete "/api/v1/categories/#{category.id}", nil, headers
    assert_response :forbidden

    # checking
    headers = auth_header admin
    delete "/api/v1/categories/#{category.id}", nil, headers
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end
end
