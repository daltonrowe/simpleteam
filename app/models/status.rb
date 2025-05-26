class Status < ApplicationRecord
  belongs_to :user
  belongs_to :team

  after_create do
    self.sections = self.team.sections.map do |team_section|
      { name: team_section["name"], content: [] }
    end
  end

  def fresh?
    self.created_at.between?(team.previous_cutoff, team.next_cutoff)
  end

  def sections_with_content
    self.sections.reject { |section| section["content"].empty? }
  end
end
