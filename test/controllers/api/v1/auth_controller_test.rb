require 'test_helper'

class Api::V1::AuthControllerTest < ActionController::TestCase
  setup do
    @user = users(:customer)
  end

  test "should get request_sms" do
    get :request_sms, user: {phone: @user.phone}
    assert_response :success
  end

  test "should post verify" do
    post :verify, user: {phone: @user.phone, code: @user.sms_code}
    assert_response :success
  end

end
