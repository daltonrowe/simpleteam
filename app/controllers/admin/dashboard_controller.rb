class Admin::DashboardController < Admin::BaseController
  def index
    @team_count = Team.count
    @user_count = User.count
    @slack_installation_count = SlackInstallation.count
  end
end
