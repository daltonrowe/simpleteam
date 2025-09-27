class DailyListStatusJob < ApplicationJob
  def perform
    SlackInstallation.all.each do |installation|
      installation.teams.each do |team|
        statuses = team&.current_statuses
        blocks = BlockFormatter.block_for_statuses(statuses)

        SlackUser.where(slack_installation_id: installation.id).each do |slack_user|
          next unless slack_user.user.teams.include? team

          installation.slack_client.chat_postMessage(channel: slack_user.slack_user_id, blocks:)
        end
      end
    end
  end
end
