class Notification < ApplicationRecord
  STATUS_LIST = "status_list".freeze
  STATUS_REMINDER = "status_reminder".freeze

  LABELS = {
    STATUS_LIST => "Daily digest",
    STATUS_REMINDER => "Status reminder"
  }.freeze

  belongs_to :team

  validates :kind, presence: true

  scope :recent, -> { order(created_at: :desc) }

  # Kill switch for every outbound Slack notification, set in
  # config/initializers/settings.rb.
  def self.sending_enabled?
    Rails.configuration.x.slack.notifications_enabled
  end

  def label
    LABELS.fetch(kind, kind)
  end
end
