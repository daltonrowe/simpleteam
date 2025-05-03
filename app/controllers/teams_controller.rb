class TeamsController < ApplicationController
  require "securerandom"
  def new
    @team = Team.new(user: Current.user)
  end

  def create
    @team = Team.create(guid: SecureRandom.uuid, user: Current.user, **create_params)

    if @team.save
      redirect_to root_path, notice: "Team created!"
    else
      redirect_to new_team_path, alert: "Something went wrong."
    end
  end

  def show
    @team = Team.find(params[:id])

    redirect_to dashboard_path unless @team.user == Current.user
  end

  private

  def create_params
    params.require(:team).permit(:name)
  end
end
