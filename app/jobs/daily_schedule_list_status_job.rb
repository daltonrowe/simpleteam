class DailyScheduleListStatusJob < ApplicationJob
  def perform
    SlackInstallation.all.each do |installation|
      installation.teams.each do |team|
        SlackListStatusJob.set(wait_until: team.notification_time).perform_later(team.id)
      end
    end
  end
end
