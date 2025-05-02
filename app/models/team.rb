class Team < ApplicationRecord
  belongs_to :user
  has_many :users, through: :team_seats

  validates :name, presence: true, length: { maximum: 120 }
end
