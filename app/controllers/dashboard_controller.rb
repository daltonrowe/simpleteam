class DashboardController < ApplicationController
  def index
    @pending_seats = PendingSeat.where(email_address: Current.user.email_address)
    @team_for_status = team_for_status

    status = Status.where(team: @team_for_status, user: Current.user).order(created_at: :desc).first
    @status = status if status&.fresh?
  end

  def user
    @pending_seats = PendingSeat.where(email_address: Current.user.email_address)
  end

  private

  def team_for_status
    team = Team.find(params[:team_id]) if params[:team_id]

    if team
      return team if Current.user.member_of? team
      return redirect_to dashboard_path
    end

    Current.user.default_team
  end
end
