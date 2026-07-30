class DataQueryService
  DEFAULT_QUERY_PARAMS = {
    per_page: 30,
    page: 1,
    order: "desc",
    name: nil,
    resolution: "full"
  }.freeze

  RESOLUTIONS = %w[full weekly monthly quarterly].freeze

  LIMIT_OPTIONS = [ 25, 50, 75, 100 ].freeze
  UNLIMITED = "none".freeze

  def initialize(team:, params:)
    @team = team
    @params = params.to_h.symbolize_keys
  end

  def call
    return paginate(base_scope.order(created_at: order)) if resolution == "full"

    paginate(collapsed_records)
  end

  private

  def base_scope
    where_args = { team: @team }
    where_args[:name] = query_params[:name] if query_params[:name]

    Datum.where(**where_args)
  end

  def collapsed_records
    records = collapse_by_period(base_scope.order(created_at: :asc).to_a)
    records.reverse! if order == :desc
    records
  end

  # Applies the requested limit/page. Works for both an ActiveRecord relation
  # (full resolution) and an already-collapsed array (weekly/monthly/quarterly).
  # A limit of "none" returns everything unpaginated.
  def paginate(collection)
    return collection if unlimited?

    if collection.respond_to?(:offset)
      collection.offset(page_offset).limit(per_page)
    else
      collection[page_offset, per_page] || []
    end
  end

  def unlimited?
    query_params[:per_page].to_s.downcase == UNLIMITED
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
