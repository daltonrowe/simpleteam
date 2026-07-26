class Admin::DashboardController < Admin::BaseController
  def index
    @team_count = Team.count
    @user_count = User.count
  end
end
