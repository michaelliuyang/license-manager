require 'test_helper'

class LicensesControllerTest < ActionController::TestCase
  setup do
    @license = licenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:licenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create license" do
    assert_difference('License.count') do
      post :create, license: { applicant: @license.applicant, custom_name: @license.custom_name, expires_date: @license.expires_date, local_check: @license.local_check, local_check_type: @license.local_check_type, memo: @license.memo, publish_content: @license.publish_content, publish_reason: @license.publish_reason, user_number: @license.user_number, version: @license.version }
    end

    assert_redirected_to license_path(assigns(:license))
  end

  test "should show license" do
    get :show, id: @license
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @license
    assert_response :success
  end

  test "should update license" do
    put :update, id: @license, license: { applicant: @license.applicant, custom_name: @license.custom_name, expires_date: @license.expires_date, local_check: @license.local_check, local_check_type: @license.local_check_type, memo: @license.memo, publish_content: @license.publish_content, publish_reason: @license.publish_reason, user_number: @license.user_number, version: @license.version }
    assert_redirected_to license_path(assigns(:license))
  end

  test "should destroy license" do
    assert_difference('License.count', -1) do
      delete :destroy, id: @license
    end

    assert_redirected_to licenses_path
  end
end
