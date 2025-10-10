require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "302 when logged out" do
    get dashboard_path

    assert_redirected_to new_session_path
  end

  test "create team message when no teams" do
    user = users(:teamless_user)

    sign_in(user)
    get dashboard_path

    assert_response :success
    assert_dom "a", "Create a team"
  end

  test "list all teams when owns team" do
    user = users(:owner)

    sign_in(user)
    get dashboard_path

    assert_response :success
    assert_dom "a", "My Awesome Team"
    assert_dom "a", "Status Updates"
    assert_dom "a", "Team Settings"
  end

  test "list all teams when member of team" do
    user = users(:member)

    sign_in(user)
    get dashboard_path

    assert_response :success
    assert_dom "a", "My Awesome Team"
    assert_dom "a", "Status Updates"
  end
end
