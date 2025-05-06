# frozen_string_literal: true

class SeatComponent < ViewComponent::Base
  def initialize(seat:)
    @seat = seat
  end

  attr_reader :seat
end
