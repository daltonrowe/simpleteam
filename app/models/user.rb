class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :teams
  has_many :seats

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def display_name
    self.name || self.email_address.split("@")[0]
  end

  def all_teams
    [ *self.teams, *self.seats.map { |seat| seat.team } ]
  end

  def all_alone?
    all_teams.empty?
  end

  def multiple_teams?
    all_teams.length > 1
  end
end
