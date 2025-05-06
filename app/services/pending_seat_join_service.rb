class PendingSeatJoinService
  include EncryptionHelper

  def initialize(user:, token:)
    @user = user
    @token = token
    @pending_seat = nil
  end

  attr_accessor :user, :token, :pending_seat

  def join
    return nil unless @token

    @pending_seat = PendingSeat.find_by(token:)

    if token_valid
      confirm_user
      fill_pending_seat
    end
  end

  private

  def confirm_user
    @user.confirmed_at = Time.zone.now
    @user.save
  end

  def fill_pending_seat
    Seat.create(user: @user, team: @pending_seat.team)
    @pending_seat.destroy
  end

  def token_valid
    data = decrypt(token)
    token_email, token_date = data.split("---")

    token_email == @user.email_address && Date.parse(token_date).future?
  end
end
