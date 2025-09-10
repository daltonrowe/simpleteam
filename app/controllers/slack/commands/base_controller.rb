module Slack
  module Commands
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_slack_request!
      before_action :set_slack_installation

      allow_unauthenticated_access

      def authenticate_slack_request!
        Slack::Events::Request.new(request, { signing_secret: Rails.configuration.x.slack.signing_secret }).verify!
      rescue
        Rails.logger.info "VERIFY FAILED"
        render json: { error: "Invalid Signature" }, status: 401
      end

      def set_slack_installation
        @slack_installation = SlackInstallation.find_by(slack_team_id: params[:team_id])

        Rails.logger.info "NO SLACK TEAM" unless @slack_installation

        render json: { error: "Could not find slack team: #{params[:team_id]}" }, status: 404 unless @slack_installation
      end

      def set_user
        @user = find_or_create_slack_user(params[:user_id], @slack_installation.token)

        Rails.logger.info "NO SLACK USER" unless @user

        render json: { error: "Could not find user: #{params[:user_id]}" }, status: 404 unless @user
      end

      def set_team
        @team = @slack_installation.teams.find_by(name: params[:channel_name])
      end

      def slack_client
        @slack_client ||= Slack::Web::Client.new({ token: @slack_installation.token })
      end
    end
  end
end
