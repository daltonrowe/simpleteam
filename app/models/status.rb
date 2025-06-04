class Status < ApplicationRecord
  belongs_to :user
  belongs_to :team

  before_create do
    self.sections = team.sections.map do |team_section|
      { name: team_section["name"], content: [] }
    end
  end

  before_update do |incoming|
    self.sections = team.sections.map do |team_section|
      key = team_section["name"]
      incoming.sections.key?(key) ? format_section(team_section["name"], incoming.sections[key]) : nil
    end.compact
  end

  def fresh?
    self.created_at.between?(team.previous_cutoff, team.next_cutoff)
  end

  def sections_with_content
    self.sections.reject { |section| section["content"].empty? }
  end

  private

  def format_section(name, raw_content)
    {
      name:,
      content: raw_content.split("\n").reject(&:blank?)
    }
  end
end
