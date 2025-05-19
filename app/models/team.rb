class Team < ApplicationRecord
  belongs_to :user
  has_many :seats
  has_many :pending_seats

  validates :name, presence: true, length: { maximum: 120 }

  # metadata json:
  # ticket_link
  # slack_webhook

  def yesterday_cutoff
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
end
