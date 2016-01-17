require 'test_helper'

class Api::V1::AuthControllerTest < ActionController::TestCase
  test "should get request_sms" do
    get :request_sms
    assert_response :success
  end

  test "should get verify" do
    get :verify
    assert_response :success
  end

end
