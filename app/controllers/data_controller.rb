class DataController < ApplicationController
  allow_unauthenticated_access
  before_action :ensure_json_request
  before_action :find_team
  before_action :validate_api_key

  def index
    data = Datum.where(team: @team).all
    render json: data.to_json
  end

  private

  def validate_api_key
    head :bad_request unless @team.data_api_key && request.headers["X-API-Key"] == @team.data_api_key
  end

  def ensure_json_request
    head :not_acceptable unless request.format == :json
  end
end
