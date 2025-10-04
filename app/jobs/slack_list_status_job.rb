class SlackListStatusJob < ApplicationJob
  def perform(team_id)
    team = Team.find_by(id: team_id)
    return unless team

    statuses = team.current_statuses
    blocks = BlockFormatter.block_for_statuses(statuses)

    SlackUser.where(slack_installation_id: team.slack_installation.id).each do |slack_user|
      next unless slack_user.user.all_teams.include? team

      team.slack_installation.slack_client.chat_postMessage(channel: slack_user.slack_user_id, blocks:)
    end
  end
end
