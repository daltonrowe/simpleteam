require "test_helper"

# Simpleteam must not be able to send Slack messages. Guard against the
# capability creeping back in through code or the app's OAuth scopes.
class NoSlackMessagesTest < ActiveSupport::TestCase
  MESSAGE_METHODS = /\b(chat_post|chat_schedule|chat_update|chat_me|chat_command|files_upload|response_url)/

  test "no application code calls a Slack message-sending API" do
    offenders = Dir[Rails.root.join("{app,lib,config}/**/*.rb")].select do |path|
      File.read(path).match?(MESSAGE_METHODS)
    end

    assert_empty offenders.map { |p| Pathname(p).relative_path_from(Rails.root).to_s }
  end

  test "the Slack app manifest does not request chat:write scopes" do
    scopes = JSON.parse(File.read(Rails.root.join("slack-app-manifest.json"))).dig("oauth_config", "scopes", "bot")

    assert_empty scopes.grep(/\Achat:write/)
  end

  test "Rails scope config matches the manifest" do
    assert_not_includes Rails.configuration.x.slack.oauth_scope.split(","), "chat:write"
  end

  test "no recurring jobs are scheduled" do
    config = YAML.load_file(Rails.root.join("config/recurring.yml"))

    assert_empty config.fetch("production")
  end
end
