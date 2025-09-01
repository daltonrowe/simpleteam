class TeamsController < ApplicationController
  require "securerandom"
  include EncryptionHelper

  before_action :find_team, except: %i[new create]
  user_must_have_seat only: %i[show create_api_key]
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
    success = TeamUpdateService.new(@team, update_params).call

    if success
      redirect_to team_data_path(@team), notice: "Team updated!"
    else
      redirect_to team_data_path(@team), alert: "Something went wrong!"
    end
  end

  def create_api_key
    success = TeamUpdateService.new(@team, { "data_api_key" => SecureRandom.uuid }).call

    if success
      redirect_to team_data_store_path(@team), notice: "New API key created!"
    else
      redirect_to team_data_store_path(@team), notice: "Something went wrong!"
    end
  end

  def data_store
    render "data_store"
  end

  private

  def create_params
    params.require(:team).permit(:name)
  end

  def update_params
    params.require(:team).permit(
      :name,
      :section_0_name,
      :section_0_description,
      :section_1_name,
      :section_1_description,
      :section_2_name,
      :section_2_description,
      :notifaction_time,
      :end_of_day,
      :time_zone,
      :project_management_url
    )
  end
end
