class Team::Seat < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :team, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end
