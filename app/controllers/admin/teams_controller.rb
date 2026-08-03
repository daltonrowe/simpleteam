class Admin::TeamsController < Admin::BaseController
  def index
    @teams = Team.includes(:user, :seats).order(:name)
  end

  def destroy
    team = Team.find(params[:id])
    team.destroy

    redirect_to admin_teams_path, notice: "Team deleted.", status: :see_other
  end
end
