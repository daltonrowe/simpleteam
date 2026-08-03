class Admin::DashboardController < Admin::BaseController
  def index
    @team_count = Team.count
    @user_count = User.count
    @slack_installation_count = SlackInstallation.count
    @notifications_sent_today = Notification.where(created_at: Time.current.beginning_of_day..).count
  end
end
