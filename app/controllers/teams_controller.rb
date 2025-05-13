class TeamsController < ApplicationController
  require "securerandom"
  include EncryptionHelper

  before_action :find_team, except: %i[new create]
  user_must_have_seat only: %i[show]
  user_must_own_team only: %i[edit]

  def new
    @team = Team.new(user: Current.user)
  end

  def create
    @team = Team.new(guid: SecureRandom.uuid, user: Current.user, **create_params)

    if @team.save
      redirect_to edit_team_path(@team.guid), notice: "Team created!"
    else
      redirect_to new_team_path, alert: "Something went wrong."
    end
  end

  def show; end
  def edit; end

  private

  def create_params
    params.require(:team).permit(:name)
  end
end
