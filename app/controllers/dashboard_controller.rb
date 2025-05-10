class DashboardController < ApplicationController
  def index
    @teams = Current.user.teams
    @seats = Current.user.seats
    @pending_seats = PendingSeat.where(email_address: Current.user.email_address)
  end

  def seats; end
end
