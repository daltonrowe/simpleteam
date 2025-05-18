class DashboardController < ApplicationController
  def index
    @pending_seats = PendingSeat.where(email_address: Current.user.email_address)
    @team_for_status = Current.user&.seats&.first&.team || Current.user&.teams&.first

    status = Status.where(team: @team_for_status, user: Current.user).order(created_at: :desc).first
    @status = status if status&.fresh?
  end

  def user
    @pending_seats = PendingSeat.where(email_address: Current.user.email_address)
  end
end
