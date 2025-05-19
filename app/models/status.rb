class Status < ApplicationRecord
  belongs_to :user
  belongs_to :team

  # allowed to be updated, part of today's batch of status updates
  def fresh?
    self.created_at.between?(team.yesterday_cutoff, team.next_cutoff)
  end
end
