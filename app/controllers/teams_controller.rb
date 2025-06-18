class TeamsController < ApplicationController
  require "securerandom"
  include EncryptionHelper

  before_action :find_team, except: %i[new create]
  user_must_have_seat only: %i[show]
  user_must_own_team only: %i[edit update]

  def new
    @team = Team.new(user: Current.user)
  end

  def create
    @team = Team.new(**create_params, id: SecureRandom.uuid, user: Current.user)

    if @team.save
      redirect_to edit_team_path(@team), notice: "Team created!"
    else
      redirect_to new_team_path, alert: "Something went wrong."
    end
  end

  def show; end
  def edit;end

  def update
    # TODO check and assign params, handle sections and time inputs

    @team.assign_attributes(update_params)

    if @team.save
      redirect_to edit_team_path(@team), notice: "Team updated!"
    else
      redirect_to edit_team_path(@team), alert: "Something went wrong."
    end
  end

  private

  def create_params
    params.require(:team).permit(:name)
  end

  def update_params
    params.require(:team).permit(:name, :sections, :notifaction_time, :end_of_day, :metadata)
  end
end
