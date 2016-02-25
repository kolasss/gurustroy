require 'test_helper'

class Api::V1::AuthControllerTest < ActionController::TestCase
  setup do
    @user = users(:customer)
  end

  test "should get request_sms" do
    stub_smsc_request
    user = users(:supplier)
    get :request_sms, user_phone: user.phone
    assert_response :success
  end

  test "should show error on request_sms if sms code not expired" do
    stub_smsc_request
    user = users(:supplier)
    get :request_sms, user_phone: user.phone
    get :request_sms, user_phone: user.phone
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should post verify" do
    post :verify, user_phone: @user.phone, user_code: @user.sms_code
    assert_response :success
  end

  test "should delete destroy_token current" do
    require_login {delete :destroy_token, token: 'current'}
    login_user @user
    assert_difference('@user.authentications.count', -1) do
      delete :destroy_token, token: 'current'
    end
    assert_response :success
  end

  test "should delete destroy_token other" do
    require_login {delete :destroy_token, token: 'other'}
    login_user @user
    assert_difference('@user.authentications.count', -1) do
      delete :destroy_token, token: 'other'
    end
    assert_response :success
  end

  test "should show error on destroy_token with invalid parameter" do
    login_user @user
    delete :destroy_token, token: 'asdf'
    assert_response :unprocessable_entity
    assert_match 'errors', response.body

    delete :destroy_token
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end
end
