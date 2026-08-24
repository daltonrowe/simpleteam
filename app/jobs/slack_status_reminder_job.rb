class SlackStatusReminderJob < ApplicationJob
  def perform(team_id, scheduled_at_iso = nil)
    return unless Notification.sending_enabled?

    team = Team.find_by(id: team_id)
    return unless team

    statuses = team.current_statuses
    blocks = BlockFormatter.block_for_status_reminder

    recipient_count = 0
    SlackUser.where(slack_installation_id: team.slack_installation.id).each do |slack_user|
      next unless slack_user.user.all_teams.include? team
      next if statuses.any? { |s| s.user == slack_user.user }

      team.slack_installation.slack_client.chat_postEphemeral(channel: team.name,
                                                              user: slack_user.slack_user_id,
                                                              blocks:)
      recipient_count += 1
    end

    team.notifications.create!(
      kind: Notification::STATUS_REMINDER,
      recipient_count:,
      scheduled_at: parse_scheduled_at(scheduled_at_iso)
    )
  end

  private

  def parse_scheduled_at(value)
    Time.iso8601(value) if value.present?
  rescue ArgumentError
    nil
  end
end
