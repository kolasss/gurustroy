require 'test_helper'

class Api::V1::TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:molotok)
    login_user users(:admin)
  end

  test "should get index" do
    get :index, category_id: categories(:instrumenti)
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post :create, category_id: categories(:instrumenti), tag: {
        name: "новый таг"
      }
    end

    assert_response 201
  end

  test "should update tag" do
    put :update, id: @tag, tag: {
      name: @tag.name
    }
    assert_response 204
  end

  test "should destroy tag" do
    assert_difference('Tag.count', -1) do
      delete :destroy, id: @tag
    end

    assert_response 204
  end
end
