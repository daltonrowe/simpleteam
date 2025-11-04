class DailyScheduleStatusReminderJob < ApplicationJob
  def perform
    SlackInstallation.all.each do |installation|
      installation.teams.each do |team|
        SlackStatusReminderJob.set(wait_until: team.notification_time - 1.hour).perform_later(team.id)
      end
    end
  end
end
