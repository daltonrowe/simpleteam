require "securerandom"

module Slack
  class SlackInstallationsController < BaseController
    skip_before_action :authenticate_slack_request!

    def create
      options = {
        client_id: Rails.configuration.x.slack.client_id,
        client_secret: Rails.configuration.x.slack.client_secret,
        code: params[:code]
      }

      auth = Slack::Web::Client.new.oauth_v2_access(options)
      token = auth.access_token
      user_id = auth.authed_user&.id
      bot_user_id = auth.bot_user_id
      team_id = auth.team&.id
      team_name = auth.team&.name
      oauth_scope = auth.scope

      installation = SlackInstallation.where(token: token).first
      installation ||= SlackInstallation.where(slack_team_id: team_id).first

      if installation
        installation.ping_if_active!
        installation.update!(
          oauth_scope:,
          activated_user_id: user_id,
          activated_user_access_token: token,
          bot_user_id:
        )

        if installation.active?
          redirect_to root_path, notice: "Slack Team already exists!"
        else
          installation.activate!(token)
        end
      else


        slack_installation = SlackInstallation.create!(
          id: SecureRandom.uuid,
          token:,
          oauth_version: :v2,
          oauth_scope:,
          slack_team_id: team_id,
          name: team_name,
          activated_user_id: user_id,
          activated_user_access_token: token,
          bot_user_id:
        )

        user = find_or_create_slack_user(user_id, token, slack_installation)
        slack_installation.update(user:)

        redirect_to root_path, notice: "Slack Team created!"
      end
    end
  end
end
