class PendingSeatsController < ApplicationController
  def create
    puts create_params
    @team = Team.find_by(guid: params[:team_id], user: Current.user)
    service = PendingSeatService.new(team: @team, pending_emails: create_params[:pending_emails])

    error = service.create_seats
    flash[:error] = error if error

    redirect_to team_path(@team.guid)
  end

  def destroy
    team = Team.find_by(guid: params[:id])
    pending_seat = team.pending_seats.find(params[:pending_seat])

    pending_seat.destroy

    redirect_to team_path(team.guid)
  end

  private

  def create_params
    params.require(:pending_seat).permit(:team_guid, :pending_emails)
  end
end
