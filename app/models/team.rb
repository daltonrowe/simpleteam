class Team < ApplicationRecord
  belongs_to :user
  has_many :seats
  has_many :pending_seats

  validates :guid, presence: true
  validates :name, presence: true, length: { maximum: 120 }
end
