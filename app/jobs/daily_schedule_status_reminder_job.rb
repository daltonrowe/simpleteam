class DailyScheduleStatusReminderJob < ApplicationJob
  def perform
    return unless Notification.sending_enabled?

    SlackInstallation.all.each do |installation|
      installation.teams.each do |team|
        send_at = team.notification_time - 1.hour
        Rails.logger.info(
          "[notify-diagnostic] reminder team=#{team.id} zone=#{team.time_zone.inspect} " \
          "local=#{send_at.strftime('%Y-%m-%d %H:%M %Z')} utc=#{send_at.utc.iso8601}"
        )
        SlackStatusReminderJob.set(wait_until: send_at).perform_later(team.id, send_at.utc.iso8601)
      end
    end
  end
end
