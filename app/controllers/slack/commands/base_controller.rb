module Slack
  module Commands
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_slack_request!

      allow_unauthenticated_access

      def authenticate_slack_request!
        Slack::Events::Request.new(request, { signing_secret: Rails.configuration.x.slack.signing_secret }).verify!
      rescue
        render json: { error: "Invalid Signature" }, status: 401
      end

      def slack_installation
        return @slack_installation if defined?(@slack_installation)

        @slack_installation = SlackInstallation.find_by(slack_team_id: params[:team_id])
      end

      def user
        return @user if defined?(@user)

        @user = find_or_create_slack_user(params[:user_id], slack_installation.token, slack_installation)
      end

      def team
        return @team if defined?(@team)

        @team = slack_installation.teams.find_by(name: params[:channel_name])
      end

      def slack_client
        @slack_client ||= Slack::Web::Client.new({ token: slack_installation.token })
      end
    end
  end
end
