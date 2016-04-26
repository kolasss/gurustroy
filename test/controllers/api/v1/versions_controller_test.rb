require 'test_helper'

class Api::V1::VersionsControllerTest < ActionController::TestCase
  setup do
    @admin = users(:admin)
  end

  test "should get index" do
    require_login {get :index, format: :json}
    login_user @admin
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:units_version)
    assert_not_nil assigns(:categories_version)
  end
end
