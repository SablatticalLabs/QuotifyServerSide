require 'test_helper'

class QuoteImagesControllerTest < ActionController::TestCase
  setup do
    @quote_image = quote_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quote_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quote_image" do
    assert_difference('QuoteImage.count') do
      post :create, quote_image: @quote_image.attributes
    end

    assert_redirected_to quote_image_path(assigns(:quote_image))
  end

  test "should show quote_image" do
    get :show, id: @quote_image.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quote_image.to_param
    assert_response :success
  end

  test "should update quote_image" do
    put :update, id: @quote_image.to_param, quote_image: @quote_image.attributes
    assert_redirected_to quote_image_path(assigns(:quote_image))
  end

  test "should destroy quote_image" do
    assert_difference('QuoteImage.count', -1) do
      delete :destroy, id: @quote_image.to_param
    end

    assert_redirected_to quote_images_path
  end
end
