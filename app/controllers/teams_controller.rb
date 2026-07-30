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

  def data_store; end
  def data_store_visualize
    @name = visualize_query_params[:name]
    @page = [ visualize_query_params[:page].to_i, 1 ].max
    @resolution = DataQueryService::RESOLUTIONS.include?(visualize_query_params[:resolution]) ? visualize_query_params[:resolution] : "full"
    @limit = visualize_limit
    @data = DataQueryService.new(team: @team, params: visualize_query_params.merge(page: @page, per_page: @limit)).call
    @data_keys = @data.first&.content_keys
    @visualize_keys = visualize_keys
    @has_next_page = @limit != DataQueryService::UNLIMITED && @data.length == @limit.to_i

    render layout: "wide"
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
      :notification_time,
      :end_of_day,
      :time_zone,
      :project_management_url
    )
  end

  def visualize_query_params
    params.permit(:name, :page, :resolution, :per_page)
  end

  def visualize_limit
    limit = visualize_query_params[:per_page].to_s
    return DataQueryService::UNLIMITED if limit == DataQueryService::UNLIMITED

    DataQueryService::LIMIT_OPTIONS.map(&:to_s).include?(limit) ? limit : "25"
  end

  def visualize_keys
    params[:keys]&.keys
  end
end
