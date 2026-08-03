require "test_helper"

class Admin::SlackInstallationsControllerTest < ActionDispatch::IntegrationTest
  test "super admin can list slack installations" do
    sign_in(users(:super_admin))

    get admin_slack_installations_path

    assert_response :success
    assert_select "td", text: "Default Slack App"
    assert_select "td", text: "Inactive Slack App"
  end

  test "a non super admin is redirected away from slack installations" do
    sign_in(users(:owner))

    get admin_slack_installations_path

    assert_redirected_to dashboard_path
  end
end
