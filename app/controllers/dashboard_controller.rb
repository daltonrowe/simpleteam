class DashboardController < ApplicationController
  def index
    @pending_seats = Current.user.pending_seats
  end
end
