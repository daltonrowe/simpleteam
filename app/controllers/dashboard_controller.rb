class DashboardController < ApplicationController
  def index
    @pending_seats = PendingSeat.where(email_address: Current.user.email_address)
  end

  def user
    @pending_seats = PendingSeat.where(email_address: Current.user.email_address)
  end
end
