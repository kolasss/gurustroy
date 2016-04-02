require 'test_helper'

class RequestSmsTest < ActionDispatch::IntegrationTest

  test "timout for request sms code" do
    skip 'убрать, это временно для разработки приложения'
    stub_smsc_request

    # первый запрос
    user_phone = '71234267890'
    get "/api/v1/auth?user_phone=#{user_phone}"
    assert_response :no_content

    sms_code = assigns(:user).sms_code

    # попробовать запросить код через 5 минут
    future_time = Time.current + 5.minutes
    travel_to future_time do
      get "/api/v1/auth?user_phone=#{user_phone}"
      assert_response :unprocessable_entity
      assert_match 'errors', response.body
    end

    # попробовать запросить код через 15 минут
    future_time = Time.current + 15.minutes
    travel_to future_time do
      get "/api/v1/auth?user_phone=#{user_phone}"
      assert_response :no_content
    end

    new_sms_code = assigns(:user).sms_code

    assert_not_equal sms_code, new_sms_code
  end

  test "phone numbers with/without + sign should be equal" do
    skip 'убрать, это временно для разработки приложения'
    stub_smsc_request

    # первый запрос
    user_phone = '71234267890'
    get "/api/v1/auth?user_phone=#{user_phone}"
    assert_response :no_content
    user = assigns(:user)

    # второй запрос
    user_phone2 = "+#{user_phone}asd"
    get "/api/v1/auth?user_phone='#{user_phone}'"
    assert_response :unprocessable_entity
    assert_match 'sms_code', response.body
    user2 = assigns(:user)

    assert_equal user.id, user2.id
  end
end
