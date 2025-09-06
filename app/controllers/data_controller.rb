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
    names = Datum.where(team: @team).order(created_at: :desc).select(:name).distinct.pluck(:name)
    render json: names.to_json
  end

  def create
    return head :bad_request unless create_params["name"] && create_params["content"]

    content = create_params["content"].to_h
    return head :bad_request unless content.is_a? Hash

    data = Datum.create!(id: SecureRandom.uuid, team: @team, **create_params)

    render json: data.to_json
  end

  def destroy
    data = Datum.find_by(team: @team, id: params[:id])
    return head :bad_request unless data

    data.destroy!
  end

  private

  def query_params
    params.permit(:name, :per_page, :page)
  end

  def create_params
    params.require(:datum).permit(:name, content: {})
  end

  def validate_api_key
    head :bad_request unless @team.data_api_key && request.headers["X-API-Key"] == @team.data_api_key
  end

  def ensure_json_request
    head :not_acceptable unless request.content_type == "application/json"
    head :not_acceptable unless request.format == :json
  end
end
