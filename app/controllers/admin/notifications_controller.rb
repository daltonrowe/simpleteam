class Admin::NotificationsController < Admin::BaseController
  SENT_LIMIT = 50

  # Simpleteam no longer sends Slack messages; this page only shows the
  # history of notifications sent before that was removed.
  def index
    @sent = Notification.includes(:team).recent.limit(SENT_LIMIT)
  end
end
