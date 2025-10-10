require "test_helper"

class SlackListStatusJobTest < ActiveJob::TestCase
  def with_stubbed_slack_client
    mock_slack_client = Minitest::Mock.new
    mock_slack_client.expect :chat_postMessage, true, channel: @slack_user_1.slack_user_id, blocks: Array
    mock_slack_client.expect :chat_postMessage, true, channel: @slack_user_2.slack_user_id, blocks: Array

    Slack::Web::Client.stub :new, mock_slack_client do
      yield
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
    assert_nil(SlackListStatusJob.perform_now("invalid-team-id"))
  end

  test "sends slack status message to each user" do
    client = with_stubbed_slack_client do
      SlackListStatusJob.perform_now(@slack_team.id)
    end

    assert(client.verify)
  end
end
