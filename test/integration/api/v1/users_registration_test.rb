require 'test_helper'

class UsersRegistrationTest < ActionDispatch::IntegrationTest

  test "registration and setup user info" do
    stub_smsc_request
    # with wrong phone number
    user_phone = '1234545'
    user_type = 'Customer'
    get "/api/v1/auth?user_phone=#{user_phone}&user_type=#{user_type}"
    assert_response :unprocessable_entity
    assert_match 'errors', response.body

    # with right phone number
    user_phone = '71234267890'
    get "/api/v1/auth?user_phone=#{user_phone}&user_type=#{user_type}"
    assert_response :no_content

    sms_code = assigns(:user).sms_code

    # wrong sms code
    post '/api/v1/auth', user_phone: user_phone, user_code: 123
    assert_response :unauthorized
    assert_match 'errors', response.body

    # correct sms code
    post '/api/v1/auth', user_phone: user_phone, user_code: sms_code
    assert_response :success
    assert_match 'auth_token', response.body

    user_info = JSON.parse(response.body)
    user_id = user_info['user_id']
    auth_token = user_info['auth_token']

    # with wrong token
    headers = {Authorization: "wrong"}
    get "/api/v1/users/#{user_id}"
    assert_response :unauthorized

    # with right token
    headers = {Authorization: "Bearer #{auth_token}"}
    get "/api/v1/users/#{user_id}", nil, headers
    assert_response :success
    assert_match user_phone, response.body

    # update user info
    headers = {Authorization: "Bearer #{auth_token}"}
    user_name = 'Иван Васильевич'
    user_company = 'ОАО Нефть'
    put "/api/v1/users/#{user_id}", {user: {name: user_name, company: user_company}}, headers
    assert_response :success
    # checking
    get "/api/v1/users/#{user_id}", nil, headers
    assert_match user_name, response.body
    assert_match user_company, response.body
  end

  test 'update user without right to update' do
    first_user = users(:supplier)
    second_user = users(:customer)
    headers = auth_header first_user
    user_name = 'Иван Васильевич'
    user_company = 'ОАО Нефть'
    put "/api/v1/users/#{second_user.id}", {
        user: {name: user_name, company: user_company}
      }, headers
    assert_response :forbidden
    # checking
    get "/api/v1/users/#{second_user.id}", nil, headers
    assert_no_match user_name, response.body
    assert_no_match user_company, response.body
  end
end
