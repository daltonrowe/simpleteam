# frozen_string_literal: true

class PendingSeatComponent < ViewComponent::Base
  def initialize(pending_seat:)
    @pending_seat = pending_seat
  end

  attr_reader :pending_seat
end
