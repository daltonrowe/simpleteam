require "securerandom"
require "block_formatter"

module Slack
  module Commands
    class SimpleTeamController < BaseController
      EDIT_STATUS = "edit-status"
      EDIT_STATUS_CONFIRM = "edit-status-confirm"
      ADD_STATUS_CONFIRM = "add-status-confirm"
      CALLBACKS = [ EDIT_STATUS, EDIT_STATUS_CONFIRM, ADD_STATUS_CONFIRM ].freeze

      def index
        case params[:text]
        when "create team"
          render json: create_team
        when "status"
          render json: list_status
        when "add"
          add_status_modal
          head :no_content
        when "join team"
          render json: join_team
        else
          render json: { response_type: "ephemeral", text: "Unknown option: #{params[:text]} :grimacing:" }
        end
      end

      def confirm(payload, slack_installation, user, callback)
        @slack_installation = slack_installation
        @user = user

        case callback
        when EDIT_STATUS
          edit_status_modal(payload)
        when ADD_STATUS_CONFIRM
          add_status(payload)
        when EDIT_STATUS_CONFIRM
          edit_status(payload)
        end
      end

      private

      def list_status
        statuses = team&.current_statuses

        if statuses.blank?
          { response_type: "ephemeral", text: "No statuses have been submitted. :disappointed:" }
        else
          {
            response_type: "ephemeral",
            blocks: BlockFormatter.block_for_statuses(statuses)
          }
        end
      end

      def create_team
        team = Team.create_with(id: SecureRandom.uuid, user:)
                   .find_or_create_by(slack_installation:, name: params[:channel_name])
        Seat.find_or_create_by(user:, team:)

        { response_type: "ephemeral", text: "Created #{params[:channel_name]} team! :partying_face:" }
      end

      def join_team
        if team
          if Seat.find_or_create_by(user:, team:)
            { response_type: "ephemeral", text: "You joined the #{params[:channel_name]} team! :tada:" }
          else
            { response_type: "ephemeral", text: "Failed to join the #{params[:channel_name]} team! :boom:" }
          end
        else
          { response_type: "ephemeral", text: "Sorry, #{params[:channel_name]} team does not exist. :disappointed:" }
        end
      end

      def add_status_modal
        existing_status = team.current_statuses.where(user:).first
        view = if existing_status
                 edit_status_view(existing_status)
               else
                 add_status_view
               end

        slack_client.views_open(trigger_id: params["trigger_id"], view: view)
      end

      def add_status(payload)
        @team = Team.find(payload.view.private_metadata)

        section_data = {}
        payload.view.state.values.to_h.map { |_k, v| v.to_h }.each do |section|
          section_data[section.keys.first.to_s] = section.values.first.value
        end

        status = Status.new(user:, team:, id: SecureRandom.uuid)
        status.update_sections(section_data)
        status.save!

        slack_client.chat_postEphemeral(channel: team.name,
                                  user: user.slack_users.first.slack_user_id,
                                  text: "Status was added! :raised_hands:")
        { "response_action": "clear" }
      end

      def edit_status_modal(payload)
        status_id = payload.actions.first.value
        status = Status.find status_id

        slack_client.views_open(trigger_id: payload.trigger_id, view: edit_status_view(status))
      end

      def edit_status(payload)
        status = Status.find(payload.view.private_metadata)
        @team = status.team

        section_data = {}
        payload.view.state.values.to_h.map { |_k, v| v.to_h }.each do |section|
          section_data[section.keys.first.to_s] = section.values.first.value
        end
        status.update_sections(section_data)

        slack_client.chat_postEphemeral(channel: team.name,
                                        user: user.slack_users.first.slack_user_id,
                                        text: "Status was updated! :raised_hands:")
        { "response_action": "clear" }
      end

      private

      def edit_status_view(status)
        inputs = status.sections.map do |section|
          {
            "type": "input",
            "element": {
              "type": "plain_text_input",
              "multiline": true,
              "action_id": section["name"],
              "initial_value": section["content"].join('\n')
            },
            "label": {
              "type": "plain_text",
              "text": section["name"].titleize,
              "emoji": true
            }
          }
        end

        {
          "title": {
            "type": "plain_text",
            "text": "Edit Status"
          },
          "submit": {
            "type": "plain_text",
            "text": "Submit"
          },
          "blocks": [
            {
              "type": "header",
              "text": {
                "type": "plain_text",
                "text": "#{BlockFormatter.date_string(status.created_at)} Status",
                "emoji": true
              }
            }
          ] + inputs,
          "type": "modal",
          "callback_id": EDIT_STATUS_CONFIRM,
          "private_metadata": status.id
        }
      end

      def add_status_view
        inputs = team.sections.map do |section|
          {
            "type": "input",
            "element": {
              "type": "plain_text_input",
              "multiline": true,
              "action_id": section["name"],
              "placeholder": {
                "type": "plain_text",
                "text": section["description"] || "Write something..."
              }
            },
            "label": {
              "type": "plain_text",
              "text": section["name"].titleize,
              "emoji": true
            }
          }
        end

        {
          "title": {
            "type": "plain_text",
            "text": "Add Status"
          },
          "submit": {
            "type": "plain_text",
            "text": "Submit"
          },
          "blocks": inputs,
          "type": "modal",
          "callback_id": ADD_STATUS_CONFIRM,
          "private_metadata": team.id
        }
      end
    end
  end
end
