class Status < ApplicationRecord
  belongs_to :user
  belongs_to :team

  def fresh?
    self.created_at.between?(team.previous_cutoff, team.next_cutoff)
  end

  def sections_with_content
    self.sections.reject { |section| section["content"].empty? }
  end

  def update_sections(incoming)
    self.sections = team.sections.map do |team_section|
      key = team_section["name"]
      incoming.key?(key) ? format_section(team_section["name"], incoming[key]) : nil
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
