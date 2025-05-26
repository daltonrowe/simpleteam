class DashboardController < ApplicationController
  def index
    @pending_seats = Current.user.pending_seats
    @team = dashboard_team
    @team_statuses = @team&.current_statuses
    @status = dashboard_status

    render layout: @team ? "wide" : "application"
  end

  private

  def dashboard_team
    team = Team.find(params[:team_id]) if params[:team_id]

    if team
      return team if Current.user.member_of? team
      return redirect_to dashboard_path
    end

    Current.user.default_team
  end

  def dashboard_status
    return nil unless @team

    status = @team_statuses&.where(user: Current.user)&.first
    @status = status || Status.new(team: @team, user: Current.user, id: SecureRandom.uuid)
  end
end
