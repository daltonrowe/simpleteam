class SeatsController < ApplicationController
  def destroy
    seat = Current.user.seats.find_by(team: @team)

    puts Current.user.seats
    puts seat
    seat.destroy
  end
end
