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

  def label
    LABELS.fetch(kind, kind)
  end
end
