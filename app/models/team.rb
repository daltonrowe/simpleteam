class Team < ApplicationRecord
  DEFAULT_TIME_ZONE = "Central Time (US & Canada)".freeze

  belongs_to :slack_installation, optional: true
  belongs_to :user
  has_many :seats, dependent: :destroy
  has_many :pending_seats, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :data, class_name: "Datum", dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { maximum: 120 }
  validates :time_zone, presence: true

  alias_attribute :original_end_of_day, :end_of_day
  alias_attribute :original_notification_time, :notification_time

  METADATA_ATTRIBUTES = [
    "project_management_url",
    "data_api_key"
  ].freeze

  def end_of_day
    next_occurrence_in_team_zone(self.original_end_of_day)
  end

  def notification_time
    next_occurrence_in_team_zone(self.original_notification_time)
  end

  # The resolved time zone (never nil), for converting stored UTC timestamps
  # into the team's local wall clock.
  def zone
    team_zone
  end

  def previous_cutoff
    next_cutoff - 1.day
  end

  def next_cutoff
    end_of_day
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

  # Always resolve to a valid zone. A blank or unrecognized `time_zone` would
  # otherwise make `ActiveSupport::TimeZone[...]` return nil (or raise on nil),
  # silently falling back to the app default (UTC) and sending notifications at
  # the wrong wall-clock time. Fall back to the team default instead.
  def team_zone
    ActiveSupport::TimeZone[self.time_zone.to_s] || ActiveSupport::TimeZone[DEFAULT_TIME_ZONE]
  end

  def next_occurrence_in_team_zone(time)
    zone = team_zone
    today = zone.today
    candidate = zone.local(today.year, today.month, today.day, time.hour, time.min, time.sec)
    candidate <= Time.current ? candidate + 1.day : candidate
  end
end
