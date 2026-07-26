# frozen_string_literal: true

class PendingSeatComponent < ApplicationComponent
  def initialize(pending_seat:, user:)
    @pending_seat = pending_seat
    @user = user
  end

  attr_reader :pending_seat, :user

  def owner
    user.owns?(pending_seat.team)
  end
end
