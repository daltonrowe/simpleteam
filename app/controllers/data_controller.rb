class DataController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token
  before_action :ensure_json_request
  before_action :find_team
  before_action :validate_api_key

  def index
    data = DataQueryService.new(team: @team, params: query_params).call
    render json: data.to_json
  end

  def names
    names = @team.data_names
    render json: names.to_json
  end

  def create
    return head :bad_request unless create_params[:name] && create_params[:content] && create_params[:content].instance_of?(ActionController::Parameters)

    content = create_params[:content].permit!.to_h
    return head :bad_request unless content.is_a? Hash
    return head :bad_request unless content.length.positive?
    return head :bad_request unless create_params[:sha].nil? || create_params[:sha].is_a?(String)

    sha = create_params[:sha] || (content["sha"] if content["sha"].is_a?(String))

    data = Datum.create!(id: SecureRandom.uuid, team: @team, name: create_params[:name], sha:, content:)

    render json: data.to_json
  end

  def destroy
    data = Datum.find_by(team: @team, id: params[:id])
    return head :bad_request unless data

    data.destroy!
  end

  private

  def query_params
    params.permit(:name, :sha, :per_page, :page, :order, :resolution)
  end

  def create_params
    # TODO: Struggling to permit arbitrary data in a hash from params
    {
      name: params["name"],
      content: params["content"],
      sha: params["sha"].presence
    }
  end

  def validate_api_key
    head :bad_request unless @team.data_api_key && request.headers["X-API-Key"] == @team.data_api_key
  end

  def ensure_json_request
    return if request.content_type == "application/json" && request.format == :json

    head :not_acceptable
  end
end
