require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "label maps a known kind to a human string" do
    assert_equal "Daily digest", Notification.new(kind: Notification::STATUS_LIST).label
    assert_equal "Status reminder", Notification.new(kind: Notification::STATUS_REMINDER).label
  end

  test "label falls back to the raw kind" do
    assert_equal "mystery", Notification.new(kind: "mystery").label
  end

  test "requires a kind" do
    notification = Notification.new(team: teams(:slack_team))

    assert_not notification.valid?
    assert_includes notification.errors[:kind], "can't be blank"
  end
end
