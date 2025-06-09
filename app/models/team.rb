class Team < ApplicationRecord
  belongs_to :user
  has_many :seats
  has_many :pending_seats

  validates :name, presence: true, length: { maximum: 120 }

  # metadata json:
  # ticket_link
  # slack_webhook

  def previous_cutoff
    next_cutoff - 1.day
  end

  def next_cutoff
    cutoff_date = Time.zone.now.change(
      { hour: self.end_of_day.hour, minutes: self.end_of_day.min }
    )

    if Time.zone.now >= cutoff_date
      cutoff_date + 1.day
    else
      cutoff_date
    end
  end

  def current_statuses
    Status.where(
      team: self,
      created_at: self.previous_cutoff..self.next_cutoff
    ).order(created_at: :desc)
  end

  def previous_statuses(before:, after:)
    Status.where(
      team: self,
      created_at: before..after
    ).order(created_at: :desc)
  end

  def pending_seats_for(user)
    self.pending_seats.find_by(email_address: user.email_address)
  end

  def member_count
    self.seats.length + 1
  end
end
