require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "super admin sees the dashboard with a notifications card" do
    sign_in(users(:super_admin))

    get admin_root_path

    assert_response :success
    assert_select "a[href=?]", admin_notifications_path
  end

  test "a non super admin is redirected away from the dashboard" do
    sign_in(users(:owner))

    get admin_root_path

    assert_redirected_to dashboard_path
  end
end
