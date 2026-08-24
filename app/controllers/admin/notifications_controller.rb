class Admin::NotificationsController < Admin::BaseController
  SENT_LIMIT = 50

  def index
    @scheduled = Notification.sending_enabled? ? scheduled_notifications : []
    @sent = Notification.includes(:team).recent.limit(SENT_LIMIT)
  end

  private

  # Only teams attached to a Slack installation get scheduled, mirroring
  # DailyScheduleListStatusJob / DailyScheduleStatusReminderJob. The reminder
  # fires an hour before the digest, matching the jobs.
  def scheduled_notifications
    Team.where.not(slack_installation_id: nil).includes(:slack_installation).flat_map do |team|
      [
        { team:, kind: Notification::STATUS_REMINDER, at: team.next_notification_time - 1.hour },
        { team:, kind: Notification::STATUS_LIST, at: team.next_notification_time }
      ]
    end.sort_by { |entry| entry[:at] }
  end
end
