class Team < ApplicationRecord
  belongs_to :slack_installation, optional: true
  belongs_to :user
  has_many :seats, dependent: :destroy
  has_many :pending_seats, dependent: :destroy

  validates :name, presence: true, length: { maximum: 120 }

  alias_attribute :original_end_of_day, :end_of_day
  alias_attribute :original_notification_time, :notification_time

  METADATA_ATTRIBUTES = [
    "project_management_url",
    "data_api_key"
  ].freeze

  def end_of_day
    in_team_zone(self.original_end_of_day)
  end

  def notification_time
    in_team_zone(self.original_notification_time)
  end

  def previous_cutoff
    next_cutoff - 1.day
  end

  def next_cutoff
    cutoff_date = end_of_day

    if Time.current >= cutoff_date
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
      created_at: after..before
    ).order(created_at: :desc)
  end

  def most_recent_statuses
    Status.where(
      team: self,
    ).order(created_at: :desc).limit(member_count)
  end

  def pending_seats_for(user)
    self.pending_seats.find_by(email_address: user.email_address)
  end

  def member_count
    self.seats.length + 1
  end

  def data_names
    Datum.where(team: self).order(created_at: :desc).select(:name).distinct.pluck(:name)
  end

  def project_managementment_url
    self.metadata.dig("project_management_url")
  end

  # TODO: handle with method missing
  def data_api_key
    self.metadata.dig("data_api_key")
  end

  private

  def in_team_zone(time)
    zone = ActiveSupport::TimeZone[self.time_zone] || Time.zone
    today = zone.today
    zone.local(today.year, today.month, today.day, time.hour, time.min, time.sec)
  end
end
