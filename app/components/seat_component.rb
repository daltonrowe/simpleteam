# frozen_string_literal: true

class SeatComponent < ViewComponent::Base
  def initialize(seat:, show: :team, action: "Leave")
    @seat = seat
    @show = show
    @action = action
  end

  attr_reader :seat, :show, :action

  def name
    return seat.user.display_name if show == :user
    return seat.user.email_address if show == :email

    seat.team.name
  end
end
