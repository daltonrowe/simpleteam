require "test_helper"

class SlackStatusReminderJobTest < ActiveJob::TestCase
  def with_stubbed_slack_client
    mock_slack_client = Minitest::Mock.new
    mock_slack_client.expect :chat_postEphemeral, true, channel: @slack_team.name, user: @slack_user_1.slack_user_id, blocks: Array
    mock_slack_client.expect :chat_postEphemeral, true, channel: @slack_team.name, user: @slack_user_2.slack_user_id, blocks: Array

    with_slack_notifications_enabled do
      Slack::Web::Client.stub :new, mock_slack_client do
        yield
      end
    end

    mock_slack_client
  end

  setup do
    @slack_installation = slack_installations(:default)
    @slack_team = teams(:slack_team)
    @slack_user_1 = slack_users(:default)
    @slack_user_2 = slack_users(:rando)
    seats(:slack_member)
    seats(:slack_rando)
  end

  test "handles invalid/missing team ids" do
    assert_nil(SlackStatusReminderJob.perform_now("invalid-team-id"))
  end

  test "reminds each user without a status and records the notification" do
    with_stubbed_slack_client do
      SlackStatusReminderJob.perform_now(@slack_team.id)
    end

    notifications = @slack_team.notifications.where(kind: Notification::STATUS_REMINDER)
    assert_equal 1, notifications.count
    assert_equal 2, notifications.last.recipient_count
  end

  test "sends nothing when slack notifications are disabled" do
    SlackStatusReminderJob.perform_now(@slack_team.id)

    assert_empty @slack_team.notifications
  end
end
