class PendingSeatsController < ApplicationController
  user_must_own_team except: %i[destroy]
  user_must_have_pending_seat only: %i[destroy]

  def create
    PendingSeatInviteService.new(team: @team, pending_emails: create_params[:pending_emails]).create_seats

    redirect_to team_path(@team.guid)
  end

  def destroy
    @pending_seat.destroy

    redirect_to team_path(@team.guid)
  end

  private

  def create_params
    params.require(:pending_seat).permit(:team_guid, :pending_emails)
  end
end
