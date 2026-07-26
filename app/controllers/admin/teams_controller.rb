class Admin::TeamsController < Admin::BaseController
  def index
    @teams = Team.includes(:user, :seats).order(:name)
  end
end
