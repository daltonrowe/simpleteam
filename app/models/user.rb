class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :teams
  has_many :slack_users
  has_many :seats, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def display_name
    self.name || self.email_address.split("@")[0]
  end

  def all_teams
    # An owner can also hold a seat on their own team, so dedupe to avoid
    # listing (and notifying for) the same team twice.
    [ *self.teams, *self.seats.map { |seat| seat.team } ].uniq
  end

  def all_alone?
    all_teams.empty?
  end

  def multiple_teams?
    all_teams.length > 1
  end

  def member_of?(team)
    owns?(team) || self.seats.where(team:).any?
  end

  # Super admins act as the owner of every team, so they pass every
  # ownership check regardless of who the team actually belongs to.
  def owns?(team)
    super_admin? || self == team.user
  end

  def default_team
    self&.teams&.first || self&.seats&.first&.team
  end

  def pending_seats
    PendingSeat.where(email_address: self.email_address)
  end

  def unconfirmed?
    self.confirmed_at.nil?
  end

  def confirmed?
    !unconfirmed?
  end
end
