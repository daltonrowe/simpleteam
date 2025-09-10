require "ostruct"

module Slack
  module Commands
    class InteractivityController < BaseController
      before_action :set_user

      def index
        payload = JSON.parse(params[:payload], object_class: OpenStruct)
        callback = payload&.actions&.first&.action_id || payload&.view&.callback_id
        controller = case callback
                     when *SimpleTeamController::CALLBACKS
                       SimpleTeamController.new
                     else
                       render status: :bad_request, json: "Action not recognized" and return
                     end

        render json: controller.confirm(payload, @slack_installation, @user, callback)
      end

      private

      def payload_params
        @payload_params ||= JSON.parse(params[:payload], object_class: OpenStruct)
      end

      def set_slack_installation
        @slack_installation = SlackInstallation.find_by(slack_team_id: payload_params.team.id)

        render json: { error: "Could not find team: #{params[:team_id]}" }, status: 404 unless @slack_installation
      end

      def set_user
        @user = find_or_create_slack_user(payload_params.user.id, @slack_installation.token)

        Rails.logger.info "NO SLACK USER" unless @user

        render json: { error: "Could not find user: #{payload_params.user.id}" }, status: 404 unless @user
      end
    end
  end
end
