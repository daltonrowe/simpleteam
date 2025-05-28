class PendingSeatInviteService
  include EncryptionHelper

  def initialize(team:, pending_emails:)
    @team = team
    @pending_emails = pending_emails
  end

  attr_accessor :team, :pending_emails

  def create_seats
    valid_emails.each do |email_address|
      expires_at = Time.zone.now + 14.days
      pending_seat = PendingSeat.create(team:,
                                        email_address:,
                                        token: user_token(email_address, expires_at, "pending_seat"),
                                        expires_at:)

      if User.find_by(email_address:)
        PendingSeatMailer.invite(email_address:, pending_seat:).deliver_later
      else
        PendingSeatMailer.join(email_address:, pending_seat:).deliver_later
      end
    end
  end

  private

  def valid_emails
    pending_emails.gsub(/\s+/, "").split(",")
  end
end
