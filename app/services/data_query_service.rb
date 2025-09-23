class DataQueryService
  DEFAULT_QUERY_PARAMS = {
    per_page: 30,
    page: 1,
    order: "desc",
    name: nil
  }.freeze

  def initialize(team:, params:)
    @team = team
    @params = params.to_h.symbolize_keys
  end

  def call
    where_args = {
      team: @team
    }

    where_args[:name] = query_params[:name] if query_params[:name]

    Datum.where(**where_args)
      .order(created_at: query_params[:order].to_sym)
      .offset(page_offset)
      .limit(query_params[:per_page])
  end

  private

  def query_params
    @query_params ||= query_params = DEFAULT_QUERY_PARAMS.merge(@params)
  end

  def page_offset
    query_params[:per_page].to_i * (query_params[:page].to_i - 1)
  end
end
