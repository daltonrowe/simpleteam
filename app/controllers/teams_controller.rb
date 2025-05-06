class TeamsController < ApplicationController
  require "securerandom"
  include EncryptionHelper

  before_action :find_team, except: %i[new create]
  user_must_have_seat only: %i[show]

  def new
    @team = Team.new(user: Current.user)
  end

  def create
    @team = Team.new(guid: SecureRandom.uuid, user: Current.user, **create_params)

    if @team.save
      redirect_to root_path, notice: "Team created!"
    else
      redirect_to new_team_path, alert: "Something went wrong."
    end
  end

  def show
    @team = Team.find_by(guid: params[:id])
    redirect_to dashboard_path unless @team.user == Current.user
  end

  private

  def create_params
    params.require(:team).permit(:name)
  end
end
