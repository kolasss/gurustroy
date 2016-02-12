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

  test "should get revocate_current" do
    require_login {get :revocate_current}
    login_user @user
    get :revocate_current
    assert_response :success
  end

  test "should get revocate_other" do
    require_login {get :revocate_other}
    login_user @user
    get :revocate_other
    assert_response :success
  end
end
