# frozen_string_literal: true

class PendingSeatComponent < ViewComponent::Base
  def initialize(pending_seat:, user:)
    @pending_seat = pending_seat
    @user = user
  end

  attr_reader :pending_seat, :user

  def owner
    pending_seat.team.user == user
  end
end
