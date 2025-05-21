class Status < ApplicationRecord
  belongs_to :user
  belongs_to :team

  # allowed to be updated, part of today's batch of status updates
  def fresh?
    self.created_at.between?(team.previous_cutoff, team.next_cutoff)
  end

  # TODO: maybe move to AR callback
  def setup_new_sections
    self.sections = self.team.sections.map do |team_section|
      { name: team_section["name"], content: [] }
    end
  end

  def sections_with_content
    self.sections.reject { |section| section["content"].empty? }
  end
end
