require "test_helper"

class Admin::NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "super admin can view sent notification history" do
    team = teams(:slack_team)
    team.notifications.create!(kind: Notification::STATUS_LIST, recipient_count: 3)
    sign_in(users(:super_admin))

    get admin_notifications_path

    assert_response :success
    assert_select "h2", text: "Scheduled", count: 0
    assert_select "h2", text: "Recently Sent"
    # The slack_team is connected, so its sent notification shows up.
    assert_select "td", text: teams(:slack_team).name
  end

  test "a non super admin is redirected away from notifications" do
    sign_in(users(:owner))

    get admin_notifications_path

    assert_redirected_to dashboard_path
  end
end
