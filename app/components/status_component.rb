# frozen_string_literal: true

class StatusComponent < ViewComponent::Base
  def initialize(seat: nil, team: nil)
    @seat = seat
    @team = team || seat.team
  end

  attr_accessor :team
end
