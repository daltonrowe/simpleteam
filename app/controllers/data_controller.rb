class DataController < ApplicationController
  allow_unauthenticated_access
  before_action :ensure_json_request
  before_action :find_team
  before_action :validate_api_key

  def index
    data = DataQueryService.new(team: @team, params: query_params).call
    render json: data.to_json
  end

  def names
    names = Datum.where(team: @team).select(:name).distinct
    render json: names.to_json
  end

  private

  def query_params
    params.permit(:name, :per_page, :page)
  end

  def validate_api_key
    head :bad_request unless @team.data_api_key && request.headers["X-API-Key"] == @team.data_api_key
  end

  def ensure_json_request
    head :not_acceptable unless request.format == :json
  end
end
