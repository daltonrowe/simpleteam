class StatusCreateService
  def initialize(status:, user:, sections:, team:)
    @status = status
    @user = user
    @status_sections = sections
    @team = team
  end

  attr_accessor :status, :user, :status_sections, :team

  def process_and_save
    status_attrs = {
      user:,
      team:,
      sections: valid_sections
    }

    status.update(status_attrs)
  end

  private

  def valid_sections
    team.sections.map do |team_section|
      key = team_section["name"].to_sym
      status_sections.key?(key) ? format_section(team_section["name"], status_sections[key]) : nil
    end.compact
  end

  def format_section(name, raw_content)
    {
      name:,
      content: raw_content.split("\n").reject(&:blank?)
    }
  end
end
