require 'test_helper'

class SystemConfigsControllerTest < ActionController::TestCase
  setup do
    @system_config = system_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_config" do
    assert_difference('SystemConfig.count') do
      post :create, system_config: { license_path: @system_config.license_path, site_name: @system_config.site_name }
    end

    assert_redirected_to system_config_path(assigns(:system_config))
  end

  test "should show system_config" do
    get :show, id: @system_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @system_config
    assert_response :success
  end

  test "should update system_config" do
    put :update, id: @system_config, system_config: { license_path: @system_config.license_path, site_name: @system_config.site_name }
    assert_redirected_to system_config_path(assigns(:system_config))
  end

  test "should destroy system_config" do
    assert_difference('SystemConfig.count', -1) do
      delete :destroy, id: @system_config
    end

    assert_redirected_to system_configs_path
  end
end
