class DataQueryService
  DEFAULT_QUERY_PARAMS = {
    per_page: 30,
    page: 1,
    name: nil,
    order: "desc"
  }.freeze

  def initialize(team:, params:)
    @team = team
    @params = params.to_h.symbolize_keys
  end

  attr_reader :data_query

  def call
    query_params = DEFAULT_QUERY_PARAMS.merge(@params)

    where_args = {
      team: @team
    }

    where_args[:name] = query_params[:name] if query_params[:name]

    Datum.where(**where_args)
      .order(created_at: query_params[:order].to_sym)
      .limit(query_params[:per_page])
  end

  private
end
