class PendingSeatService
  def initialize(team:, pending_emails:)
    @team = team
    @pending_emails = pending_emails
  end

  attr_accessor :team, :pending_emails

  def create_seats
    errors = []

    valid_emails.each do |email_address|
      PendingSeat.create(team:, email_address:)
    end

    errors
  end

  private

  def valid_emails
    pending_emails.gsub(/\s+/, "").split(",")
  end
end
