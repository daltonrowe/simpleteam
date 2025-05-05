class Team::PendingSeat < ApplicationRecord
  belongs_to :team

  validates :team, presence: true
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
