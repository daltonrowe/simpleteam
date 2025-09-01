class DataQueryService
  def initialize(team:, params:)
    @team = team
    @params = params
  end

  attr_reader :data_query

  def call
    @data_query = Datum.where(team: @team)
  end

  private
end
