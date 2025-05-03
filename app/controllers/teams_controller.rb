class TeamsController < ApplicationController
  def new
    @team = Team.new(user: Current.user)
  end

  def create
    @team = Team.create(user: Current.user, **create_params)

    if @team.save
      redirect_to root_path, notice: "Team created!"
    else
      redirect_to new_team_path, alert: "Something went wrong."
    end
  end

  def show
    @team = Team.find(params[:id])
  end

  private

  def create_params
    params.require(:team).permit(:name)
  end
end
