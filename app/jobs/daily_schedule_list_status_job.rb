class DailyScheduleListStatusJob < ApplicationJob
  def perform
    SlackInstallation.all.each do |installation|
      installation.teams.each do |team|
        send_at = team.notification_time
        Rails.logger.info(
          "[notify-diagnostic] digest team=#{team.id} zone=#{team.time_zone.inspect} " \
          "local=#{send_at.strftime('%Y-%m-%d %H:%M %Z')} utc=#{send_at.utc.iso8601}"
        )
        SlackListStatusJob.set(wait_until: send_at).perform_later(team.id, send_at.utc.iso8601)
      end
    end
  end
end
