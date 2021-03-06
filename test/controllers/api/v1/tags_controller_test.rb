require 'test_helper'

class Api::V1::TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:molotok)
    @admin = users(:admin)
  end

  test "should get index" do
    require_login {get :index, category_id: categories(:instrumenti), format: :json}
    login_user @admin
    get :index, category_id: categories(:instrumenti), format: :json
    assert_response :success
    assert_not_nil assigns(:tags)
    assert_not_empty response.body
  end

  test "should create tag" do
    require_login {post :create, category_id: categories(:instrumenti)}
    login_user @admin
    assert_difference('Tag.count') do
      post :create, category_id: categories(:instrumenti), tag: {
        name: "новый таг"
      }, format: :json
    end

    assert_response 201
  end

  test "should show error on create tag" do
    login_user @admin
    assert_no_difference('Tag.count') do
      post :create, category_id: categories(:instrumenti), tag: {
        name: nil
      }, format: :json
    end

    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end

  test "should update tag" do
    require_login {put :update, id: @tag, format: :json}
    login_user @admin
    put :update, id: @tag, tag: {
      name: @tag.name
    }, format: :json
    assert_response :ok
  end

  test "should show error on update tag" do
    login_user @admin
    put :update, id: @tag, tag: {
      name: nil
    }
    assert_response :unprocessable_entity
    assert_match 'errors', response.body
  end


  test "should destroy tag" do
    require_login {delete :destroy, id: @tag}
    login_user @admin
    assert_difference('Tag.count', -1) do
      delete :destroy, id: @tag
    end

    assert_response 204
  end
end
