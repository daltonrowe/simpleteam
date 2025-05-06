class PendingSeatsController < ApplicationController
  user_must_own_team

  def create
    service = PendingSeatService.new(team: @team, pending_emails: create_params[:pending_emails])

    error = service.create_seats

    redirect_to team_path(@team.guid), alert: error
  end

  def destroy
    pending_seat = @team.pending_seats.find(params[:pending_seat])

    pending_seat.destroy

    redirect_to team_path(@team.guid)
  end

  private

  def create_params
    params.require(:pending_seat).permit(:team_guid, :pending_emails)
  end
end
