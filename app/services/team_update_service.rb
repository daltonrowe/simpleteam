class TeamUpdateService
  def initialize(team_update)
    @team_update = team_update
  end

  def call
    # TODO: Implement service logic
    @team_update
  end

  private

  attr_reader :team_update
end
