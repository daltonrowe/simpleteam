require "securerandom"
require "block_formatter"

module Slack
  module Commands
    class SimpleTeamController < BaseController
      before_action :set_slack_installation

      def index
        case params[:text]
        when "create team"
          render json: create_team
        when "status"
          render json: list_status
        when "add member"
          render json: add_member
        else
          render json: { response_type: "ephemeral", text: "Unknown option: #{params[:text]}" }
        end
      end

      private

      def list_status
        statuses = @slack_installation.teams.first&.current_statuses
        if statuses.blank?
          { response_type: "ephemeral", text: "No statuses have been submitted." }
        else
          {
            response_type: "ephemeral",
            blocks: BlockFormatter.block_for_statuses(statuses)
          }
        end
      end

      def create_team
        set_user
        team = @slack_installation.teams.find_or_create_by(name: params[:channel_name], user: @user)
        Seat.create(user: @user, team:)

        { response_type: "ephemeral", text: "Created team: #{params[:channel_name]}" }
      end

      def add_member
        set_user
        team = @slack_installation.teams.find_by(name: params[:channel_name])

        if team
          Seat.create(user: @user, team:)
          { response_type: "ephemeral", text: "Added member to #{params[:channel_name]} team." }
        else
          { response_type: "ephemeral", text: "Sorry, #{params[:channel_name]} team does not exist." }
        end
      end
    end
  end
end
