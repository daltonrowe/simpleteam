class StatusFormatterService
  def initialize(team:, sections:)
    @status_sections = sections
    @team = team
  end

  attr_accessor :team, :status_sections

  def format
    team.sections.map do |team_section|
      key = team_section["name"].to_sym
      status_sections.key?(key) ? format_section(team_section["name"], status_sections[key]) : nil
    end.compact
  end

  private

  def format_section(name, raw_content)
    {
      name:,
      content: raw_content.split("\n").reject(&:blank?)
    }
  end
end
