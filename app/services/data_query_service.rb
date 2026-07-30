class DataQueryService
  DEFAULT_QUERY_PARAMS = {
    per_page: 30,
    page: 1,
    order: "desc",
    name: nil,
    resolution: "full"
  }.freeze

  RESOLUTIONS = %w[full weekly monthly quarterly].freeze

  def initialize(team:, params:)
    @team = team
    @params = params.to_h.symbolize_keys
  end

  def call
    return paginate(base_scope.order(created_at: order)) if resolution == "full"

    records = collapse_by_period(base_scope.order(created_at: :asc).to_a)
    records.reverse! if order == :desc
    records[page_offset, per_page] || []
  end

  private

  def base_scope
    where_args = { team: @team }
    where_args[:name] = query_params[:name] if query_params[:name]

    Datum.where(**where_args)
  end

  def paginate(scope)
    scope.offset(page_offset).limit(per_page)
  end

  # Keep only the earliest entry within each week/month/quarter. `records` must
  # be ordered by created_at ascending so the first of each group is the earliest.
  def collapse_by_period(records)
    records.group_by { |datum| period_key(datum.created_at) }.values.map(&:first)
  end

  def period_key(time)
    case resolution
    when "weekly"
      date = time.to_date
      [ date.cwyear, date.cweek ]
    when "monthly" then [ time.year, time.month ]
    when "quarterly" then [ time.year, (time.month - 1) / 3 ]
    end
  end

  def resolution
    resolution = query_params[:resolution].to_s
    RESOLUTIONS.include?(resolution) ? resolution : "full"
  end

  def order
    query_params[:order].to_sym
  end

  def per_page
    query_params[:per_page].to_i
  end

  def query_params
    @query_params ||= DEFAULT_QUERY_PARAMS.merge(@params)
  end

  def page_offset
    per_page * (query_params[:page].to_i - 1)
  end
end
