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
      return true
    end

    false
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
    valid_user_token(@user.email_address, token, "pending_seat")
  end
end
