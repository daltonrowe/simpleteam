class Status < ApplicationRecord
  belongs_to :user
  belongs_to :team
  # TODO: use guids

  # allowed to be updated, part of today's batch of status updates
  def fresh?
    self.created_at.between?(team.yesterday_cutoff, team.today_cutoff)
  end
end
